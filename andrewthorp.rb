require 'sinatra/base'
require 'sinatra_more/markup_plugin'
require_relative 'lib/helpers'
require_relative 'routes/errors'
require_relative 'routes/authentication'
require_relative 'routes/posts'
require_relative 'routes/projects'

class AndrewThorp < Sinatra::Base
  register SinatraMore::MarkupPlugin
  helpers NavigationHelpers, AuthenticationHelpers, ViewHelpers
  enable :sessions
  set :session_secret, ENV["SESSION_SECRET"] || "abc123"
  set :views, "#{File.dirname(__FILE__)}/views"
  set :public_folder, "#{File.dirname(__FILE__)}/public"

  get "/" do
    haml :index, layout: true
  end

  get "/about" do
    haml :about, layout: true
  end

  get "/portfolio" do
    haml :portfolio, layout: true
  end

  get "/resume" do
    haml :resume, layout: true
  end

  # If everything went okay!
  run! if app_file == $0
end
