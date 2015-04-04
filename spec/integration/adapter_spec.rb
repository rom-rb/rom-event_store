require 'spec_helper'
require 'securerandom'
require 'json'
require 'timeout'

describe 'ROM / EventStore' do
  subject(:rom) { setup.finalize }
  let(:setup) { ROM.setup(:event_store, '127.0.0.1:1113') }
  let(:task_events) { rom.relation(:task_events) }
  let(:append_task_events) { rom.command(:task_events).append }
  let(:tasks) { [] }
  let(:all_events) { [] }
  let(:uuid_regexp) do
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
  end

  def event(type, data = {})
    all_events << {
      type: type,
      data: data.to_json
    }
    all_events.last
  end

  def create_task(author)
    task = SecureRandom.uuid
    append_task_events.by_id(task).call(event('TaskCreated', author: author))
    task
  end

  def update_task(task, data)
    append_task_events.by_id(task).call(event('TaskUpdated', data))
  end

  before do
    setup.relation(:task_events) do
      # We name the dataset differently every time to avoid resetting
      # EventStore on each test. Removing events is forbidden.
      dataset SecureRandom.hex(10)
      register_as :task_events

      def by_id(id)
        select(id)
      end
    end

    setup.commands(:task_events) do
      define(:append)
    end

    tasks << create_task('John')
    tasks << create_task('Jane')

    update_task(tasks.first, author: 'Matt')
  end

  describe 'relation' do
    it 'returns all the events of a relation' do
      # We let EventStore projections run to categorize our events
      expect(task_events).to have(3).events.before(5.seconds)
      expect(task_events).to contain(all_events)
    end

    it 'returns the events of a selected stream' do
      expect(task_events.by_id(tasks.first)).to have(2).events
    end

    it 'returns the events with additional information' do
      event = task_events.by_id(tasks[1]).one!

      expect(event[:id]).to match(uuid_regexp)
      expect(event[:number]).to be(0)
      expect(event[:created_at]).to be_instance_of(Time)
    end

    it 'subscribes to new events of a relation' do
      new_events = []

      task_events.subscribe { |event| new_events << event }

      task = create_task('Joe')
      update_task(task, status: 'Almost done')

      expect(new_events).to have(3).events.before(5.seconds)
    end
  end

  describe 'append command' do
    it 'appends new events to a stream' do
      append_task_events.by_id(tasks.first).call(
        event('TaskUpdated', author: 'Rene'),
        event('TaskCompleted')
      )

      expect(task_events.by_id(tasks.first).to_a.size).to be(4)
    end
  end
end
