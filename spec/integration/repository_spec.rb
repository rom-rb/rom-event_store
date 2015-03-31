require 'spec_helper'

describe 'Event Store repository' do
  subject(:rom) { setup.finalize }
  let(:setup) { ROM.setup(:event_store, '127.0.0.1:2113') }
  let(:repository) { rom.repositories.default }
  let(:post_data) { { title: 'Heya!', author: 'Rene' } }

  before do
    setup.relation(:posts) do
      def by_id(id)
        from_stream(id)
      end
    end

    setup.commands(:posts) do
      define(:append)
    end

    rom.command(:posts).append.call(1, type: 'PostCreated', **post_data)
  end

  describe 'env#relation' do
    it 'returns events' do
      event = rom.relation(:posts).by_id(1).one!

      expect(event).not_to be_empty
      expect(event[:type]).to eql 'PostCreated'
      expect(event[:data]).to eql post_data
    end
  end
end
