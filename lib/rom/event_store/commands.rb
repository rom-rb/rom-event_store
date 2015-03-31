require 'rom/commands/create'

module ROM
  module EventStore
    module Commands
      class Append < ROM::Commands::Create
        def call(stream, *events)
          relation.from_stream(stream).append(events)
        end
      end
    end
  end
end
