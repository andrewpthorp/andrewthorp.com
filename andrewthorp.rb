require 'sinatra/base'
require 'sinatra/partial'
require 'sinatra_more/markup_plugin'
require 'logger'

Dir['lib/**/*.rb'].each { |f| require_relative f }

class AndrewThorp < Sinatra::Base
  register Sinatra::Partial
  register SinatraMore::MarkupPlugin
  helpers AuthenticationHelper, NavigationHelper, ViewHelper
  enable :sessions
  set :session_secret, ENV["SESSION_SECRET"] || "abc123"
  set :views, "#{File.dirname(__FILE__)}/views"
  set :public_folder, "#{File.dirname(__FILE__)}/public"

  configure :development do
    enable :logging
  end

  get "/" do
    haml :index, layout: true
  end

  get "/about" do
    haml :about, layout: true
  end

  get "/portfolio" do
    @projects = Project.published
    haml :portfolio, layout: true
  end

  get "/resume" do
    haml :resume, layout: true
  end

  # If everything went okay!
  run! if app_file == $0
end
