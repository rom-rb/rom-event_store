require 'spec_helper'

describe 'Event Store repository' do
  subject(:rom) { setup.finalize }
  let(:setup) { ROM.setup(:event_store, '127.0.0.1:1113') }
  let(:repository) { rom.repositories.default }
  let(:post_created) do
    {
      type: 'PostCreated',
      data: {
        'title' => 'Heya!',
        'author' => 'Rene'
      }
    }
  end

  before do
    setup.relation(:posts) do
      def by_id(id)
        from_stream(id)
      end
    end

    setup.commands(:posts) do
      define(:append)
    end

    rom.command(:posts).append.call(1, post_created)
  end

  describe 'env#relation' do
    it 'returns events' do
      event = rom.relation(:posts).by_id(1).one!

      expect(event[:type]).to eql(post_created[:type])
      expect(event[:data]).to eql(post_created[:data])
      expect(event[:created_at]).to be_instance_of(Time)
      expect(event[:number]).to be(0)
    end
  end
end
