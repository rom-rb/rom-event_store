require 'rom/relation'

module ROM
  module EventStore
    class Relation < ROM::Relation
      forward :select, :append, :subscribe, :from, :limit

      def self.inherited(base)
        super

        base.exposed_relations.merge([:select, :subscribe, :from, :limit])
      end
    end
  end
end
