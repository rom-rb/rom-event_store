require 'estore'
require 'json'

module ROM
  module EventStore
    class Connection
      def initialize(uri)
        uri_port = uri.split(':')
        @connection = Estore::Session.new(*uri_port)
      end

      def read(stream, start, limit)
        read = @connection.read(stream, start, limit)
        read.sync.events.map { |event| dehydrate(event) }
      end

      def append(stream, events)
        @connection.append(stream, events).sync
      end

      private

      def dehydrate(wrapper)
        event = wrapper.event

        {
          id: Estore::Package.parse_uuid(event.event_id),
          type: event.event_type,
          data: event.data,
          number: event.event_number,
          created_at: Time.new(event.created)
        }
      end
    end
  end
end
