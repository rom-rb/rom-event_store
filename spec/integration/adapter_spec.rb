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

  def update_task(task, author)
    append_task_events.by_id(task).call(event('TaskUpdated', author: author))
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

    update_task(tasks.first, 'Matt')
  end

  describe 'relation' do
    it 'returns all the events of a relation' do
      # We let EventStore projections categorize the new events
      Timeout.timeout 5 do
        loop do
          break if task_events.to_a.size >= 3
          sleep(0.1)
        end
      end

      expect(task_events.to_a.size).to be(3)
      task_events.to_a.zip(all_events).each do |event, original|
        expect(event).to include(original)
      end
    end

    it 'returns the events of a selected stream' do
      events = task_events.by_id(tasks.first).to_a

      expect(events.size).to be(2)
    end

    it 'returns the events with additional information' do
      event = task_events.by_id(tasks[1]).one!

      expect(event[:id]).to match(uuid_regexp)
      expect(event[:number]).to be(0)
      expect(event[:created_at]).to be_instance_of(Time)
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
