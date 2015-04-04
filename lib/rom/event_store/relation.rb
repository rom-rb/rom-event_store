require 'rom/relation'

module ROM
  module EventStore
    class Relation < ROM::Relation
      forward :select, :append, :subscribe

      def self.inherited(base)
        super

        base.exposed_relations << :subscribe
      end
    end
  end
end
