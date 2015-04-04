require 'rom/relation'

module ROM
  module EventStore
    class Relation < ROM::Relation
      forward :select, :append
    end
  end
end
