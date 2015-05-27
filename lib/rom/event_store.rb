require 'rom'

require 'rom/event_store/version'
require 'rom/event_store/gateway'
require 'rom/event_store/relation'
require 'rom/event_store/commands'

ROM.register_adapter(:event_store, ROM::EventStore)
