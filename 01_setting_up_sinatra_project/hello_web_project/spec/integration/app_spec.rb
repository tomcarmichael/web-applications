require "spec_helper"
require "rack/test"
require_relative "../../app"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /name" do
    it 'returns 200 OK' do
      response = get('/names')
      expect(response.status).to eq(200)
    end

    it 'returns the right names' do
      response = get('/names')
      expect(response.body).to eq('Julia, Mary, Karim')
    end
  end
  
  context "POST /sort-names" do
    it 'sorts and returns a set of names' do
      response = post('/sort-names', names: "Maddy,Pablo,Matt,Ana,Tom,Jamie")
      expect(response.body).to eq('Ana,Jamie,Maddy,Matt,Pablo,Tom')
      expect(response.status).to eq(200)
    end

    it 'sorts and returns another set of names' do
      response = post('/sort-names', names: "Joe,Alice,Zoe,Julia,Kieran")
      expect(response.body).to eq('Alice,Joe,Julia,Kieran,Zoe')
      expect(response.status).to eq(200)
    end
  end
end