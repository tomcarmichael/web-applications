require "sinatra/base"
require "sinatra/reloader"

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
      register Sinatra::Reloader
  end

  get '/' do
    "testing... testing"
  end

  get '/hello' do
    name = params[:name]
    "Hello, #{name}!"
  end

  post '/submit' do
    name = params[:name]
    message = params[:message]
    "Thanks #{name}, you sent this message: '#{message}'"
  end

  get '/names' do
    "Julia, Mary, Karim"
  end
end