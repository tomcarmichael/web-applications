require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table

  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

def reset_artists_table

  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do
    reset_albums_table
    reset_artists_table
  end
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "POST /albums" do
    it 'Adds an album to the DB' do
      response = post('/albums', title: "Voyage", release_year: 2022, artist_id: 2)
      expect(response.status).to eq(200)
      repo = AlbumRepository.new
      albums = repo.all
      expect(albums.length).to eq(13)
      expect(albums.first.title).to eq('Doolittle')
      expect(albums.first.artist_id).to eq(1)
      expect(albums.last.artist_id).to eq(2)
      expect(albums.last.title).to eq('Voyage')
      expect(albums.last.release_year).to eq('2022')
    end
  end

  context "GET /artists" do
    it 'returns a list of links to all artists' do
      response = get('/artists')
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/1">Pixies</a>')
      expect(response.body).to include('<a href="/artists/4">Nina Simone</a>')
      expect(response.body).to include('<a href="/artists/2">ABBA</a>')
    end
  end

  context "GET /artists/:id" do
    it 'Returns the HTML content for artist of ID #1' do
      response = get('/artists/1')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('Genre: Rock')
    end

    it 'Returns the HTML content for album of ID #4' do
      response = get('/artists/4')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Nina Simone</h1>')
      expect(response.body).to include('Genre: Pop')
    end
  end


  context "POST /artists" do
    it 'adds an artist to the DB' do
      response = post('/artists', name: "Wild Nothing", genre: "Indie")
      expect(response.status).to eq(200)
      repo = ArtistRepository.new
      artists = repo.all
      expect(artists.length).to eq(5)
      expect(artists.first.name).to eq('Pixies')
      expect(artists.last.id).to eq(5)
      expect(artists.last.name).to eq('Wild Nothing')
      expect(artists.last.genre).to eq("Indie")
    end
  end

  context "GET /albums/:id" do
    it 'Returns the HTML content for album of ID #1' do
      response = get('/albums/1')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
    end

    it 'Returns the HTML content for album of ID #2' do
      response = get('/albums/2')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
    end
  end

  context "GET /albums" do
    it "returns a list of albums within HTML content" do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Albums</h1>')
      expect(response.body).to include('<div>Title: Doolittle')
      expect(response.body).to include('Released: 1988')
    end

    it "Generates links for each album by id" do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/1"')
      expect(response.body).to include('<a href="/albums/12"')
      expect(response.body).to include('<a href="/albums/6"')
    end
  end

end
