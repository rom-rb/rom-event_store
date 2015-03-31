require 'eventstore'
require 'json'

module ROM
  module EventStore
    class Connection
      EVENTS_CONTENT_TYPE = 'application/vnd.eventstore.events+json'

      def initialize(uri)
        uri_port = uri.split(':')
        @connection = Eventstore.new(*uri_port)
      end

      def events(category, stream_id = nil)
        stream = stream(category, stream_id)
        events = @connection.read_stream_events_forward(stream, 0, 20)
        events.sync.events.map { |event| EventMapper[event] }
      end

      def append(category, stream_id, events)
        events = events.map do |event|
          @connection.new_event(event[:type], event[:data].to_json)
        end

        @connection.write_events(stream!(category, stream_id), events).sync
      end

      private

      ConnectionFailedError = Class.new(StandardError)
      UndefinedStreamError = Class.new(StandardError)

      def stream(category, stream_id)
        stream_id ? "#{category}-#{stream_id}" : "$#{category}"
      end

      def stream!(category, stream_id)
        raise UndefinedStreamError unless stream_id
        stream(category, stream_id)
      end

      module EventMapper
        def self.[](event)
          event = event.event

          {
            id: Eventstore::Package.parse_uuid(event.event_id),
            type: event.event_type,
            data: JSON.parse(event.data),
            number: event.event_number,
            created_at: Time.new(event.created)
          }
        end
      end
    end
  end
end
