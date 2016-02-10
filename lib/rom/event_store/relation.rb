require 'rom/relation'

module ROM
  module EventStore
    class Relation < ROM::Relation
      adapter :event_store

      forward :select, :append, :subscribe, :from, :limit
    end
  end
end
