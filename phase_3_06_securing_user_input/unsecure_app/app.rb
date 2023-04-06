require 'sinatra/base'
require "sinatra/reloader"

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  post '/hello' do
    @name = sanitizer(params[:name])
    # p @name
    @name = params[:name]
    return erb(:hello)
  end

  def sanitizer(string)
    string.gsub!(/\&/, '&amp;')
    string.gsub!(/\</, '&lt;')
    string.gsub!(/\>/, '&gt;')
    string.gsub!(/\"/, '&quot;')
    string.gsub!(/\'/, '&apos;')
    return string
  end
end
