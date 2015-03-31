require 'net/http'
require 'json'
require 'securerandom'
require 'transproc/all'

module ROM
  module EventStore
    class Connection
      EVENTS_CONTENT_TYPE = 'application/vnd.eventstore.events+json'

      def initialize(uri)
        uri = URI("http://#{uri}")
        @http = Net::HTTP.new(uri.host, uri.port)
      end

      def events(category, stream_id = nil)
        events = __get__(stream_uri(category, stream_id))['entries'] || []
        events.map { |event| AtomMapper[event] }
      end

      def append(category, stream_id, events)
        __post__(stream_uri!(category, stream_id), events)
      end

      private

      ConnectionFailedError = Class.new(StandardError)
      UndefinedStreamError = Class.new(StandardError)

      def stream_uri(category, stream_id)
        stream = stream_id ? "#{category}-#{stream_id}" : category
        "/streams/#{stream}?embed=body"
      end

      def stream_uri!(category, stream_id)
        raise UndefinedStreamError unless stream_id
        stream_uri(category, stream_id)
      end

      def __get__(stream)
        response = @http.get(stream, 'Accept' => 'application/json')

        case response.code.to_i
        when 200
          JSON.parse(response.body)
        when 404
          nil
        else
          raise ConnectionFailedError
        end
      end

      def __post__(stream, events)
        payload = events.map { |event| AtomMapper.prepare(event) }.to_json
        response = @http.post(stream, payload,
                              'Content-Type' => EVENTS_CONTENT_TYPE)

        case response.code.to_i
        when 201
          nil
        else
          raise ConnectionFailedError
        end
      end

      module AtomMapper
        extend Transproc::Composer

        ALIASES = {
          eventId: :id,
          eventType: :type,
          eventNumber: :number,
          updated: :created_at
        }.freeze

        ATTRS = (ALIASES.values + [:data]).freeze

        MAPPER = compose do |ops|
          ops << t(:symbolize_keys!)
          ops << t(:map_hash!, ALIASES)
          ops << t(:map_key!, :created_at, t(:to_time))
          ops << t(-> event { event.keep_if { |key| ATTRS.include?(key) } })
        end

        def self.[](event)
          if event['isJson']
            event['data'] = JSON.parse(event['data'])
            t(:symbolize_keys!)[event['data']]
          end

          MAPPER[event]
        end

        def self.prepare(event)
          {
            eventId: SecureRandom.uuid,
            eventType: event.delete(:type),
            data: event
          }
        end
      end
    end
  end
end
