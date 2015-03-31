module ROM
  module EventStore
    class Dataset
      def initialize(name, connection, options = {})
        @name = name
        @connection = connection
        @options = options
      end

      def from_stream(id)
        __new__(stream: id)
      end

      def stream
        @options[:stream]
      end

      def events
        @connection.events(@name, stream)
      end

      def append(events)
        @connection.append(@name, stream, events)
      end

      def each
        if block_given?
          events.each { |event| yield(event) }
        else
          to_enum
        end
      end

      private

      def __new__(new_opts = {})
        self.class.new(@name, @connection, @options.merge(new_opts))
      end
    end
  end
end
