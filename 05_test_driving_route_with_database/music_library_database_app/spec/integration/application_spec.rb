require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "POST /albums" do
    it 'returns 200 OK' do
      response = post('/albums', title: "Voyage", release_year: 2022, artist_id: 2)
      expect(response.status).to eq(200)
      repo = AlbumRepository.new
      albums = repo.all
      expect(albums.length).to eq(13)
      expect(albums.first.title).to eq('Doolittle')
      expect(albums.first.artist_id).to eq(1)
      expect(albums.last.artist_id).to eq(2)
      expect(albums.last.title).to eq('Voyage')
      expect(albums.last.release_year).to eq(2022)
    end
  end
end
