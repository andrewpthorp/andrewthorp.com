require 'sinatra/base'
require 'sinatra_more/markup_plugin'
Dir['lib/**/*.rb'].each { |f| require_relative f }

class AndrewThorp < Sinatra::Base
  register SinatraMore::MarkupPlugin
  helpers NavigationHelper, AuthenticationHelper, ViewHelper
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
