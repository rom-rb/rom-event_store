module ROM
  module EventStore
    class Dataset
      attr_reader :category

      def initialize(category, connection, options = {})
        @category = category
        @connection = connection
        @options = options
      end

      def select(stream)
        __new__(stream: stream)
      end

      def from(id)
        __new__(from: id)
      end

      def limit(limit)
        __new__(limit: limit)
      end

      def stream
        stream = @options[:stream]
        stream ? "#{category}-#{stream}" : "$ce-#{category}"
      end

      def events
        @connection.read(stream, @options).sync
      end

      def append(events)
        @connection.append(stream, events).sync
        events
      end

      def subscribe(&block)
        subscription = @connection.subscription(stream, @options)
        subscription.on_event(&block)
        subscription.start
      end

      def each
        with_events { |event| yield(event) }
      end

      private

      def __new__(new_opts = {})
        self.class.new(@category, @connection, @options.merge(new_opts))
      end

      def option(option, default)
        @options.fetch(option, default)
      end

      def with_events
        events.each { |event| yield(dehydrate(event)) }
      end

      def dehydrate(wrapper)
        event = wrapper.event

        {
          id: Estore::Package.parse_uuid(event.event_id),
          type: event.event_type,
          data: event.data,
          number: event.event_number,
          created_at: Time.at(event.created_epoch / 1000)
        }
      end
    end
  end
end
