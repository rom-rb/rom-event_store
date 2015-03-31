require 'rom/relation'

module ROM
  module EventStore
    class Relation < ROM::Relation
      forward :from_stream, :append
    end
  end
end
