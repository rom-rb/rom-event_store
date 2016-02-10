require 'rom/commands/create'

module ROM
  module EventStore
    module Commands
      class Create < ROM::Commands::Create
        def execute(*events)
          relation.append(events)
        end
      end
    end
  end
end
