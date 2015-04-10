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
      expect(task_events).to have(3).events.in_less_than(5.seconds)
        .and contain(all_events)
    end

    it 'returns the events of a selected stream' do
      expect(task_events.by_id(tasks.first)).to have(2).events
    end

    it 'returns batches of events' do
      batch = task_events.from(1).limit(2)

      expect(batch).to have(2).events.in_less_than(5.seconds)
        .and contain(all_events[1..2])
    end

    it 'returns the events with additional information' do
      expect(task_events).to have(3).events.in_less_than(5.seconds)
      event = task_events.to_a.last

      expect(event[:id]).to match(uuid_regexp)
      expect(event[:category]).to eql(task_events.relation.dataset.category)
      expect(event[:aggregate]).to eql(tasks[0])
      expect(event[:number]).to be(1)
      expect(event[:position]).to be(2)
      expect(event[:created_at]).to be_instance_of(Time)
    end

    it 'allows to subscribe to new events' do
      new_events = []

      task_events.by_id(tasks.first).subscribe { |event| new_events << event }

      update_task(tasks.first, status: 'Need to fix some bugs')
      update_task(tasks.first, status: 'Almost done')
      update_task(tasks.last, status: 'This should not appear')

      expect(new_events).to have(2).events.in_less_than(5.seconds)
        .and contain(all_events.last(3))
    end

    it 'allows to perform a catchup subscription' do
      sub_events = []

      task_events.by_id(tasks.first).from(0).subscribe do |event|
        sub_events << event
      end

      update_task(tasks.first, status: 'This one goes into the subscription')
      update_task(tasks.last, status: 'This one does not')

      expect(sub_events).to have(3).events.in_less_than(5.seconds)
        .and contain(all_events.values_at(0, 2) + all_events.last(2))
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
