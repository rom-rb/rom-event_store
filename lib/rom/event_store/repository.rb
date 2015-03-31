require 'rom/event_store/connection'
require 'rom/event_store/dataset'

module ROM
  module EventStore
    class Repository < ROM::Repository
      def initialize(uri)
        @connection = Connection.new(uri)
        @categories = {}
      end

      def [](name)
        @categories[name]
      end

      def dataset(name)
        @categories[name] = Dataset.new(name, connection)
      end

      def dataset?(name)
        @categories.key?(name)
      end
    end
  end
end
