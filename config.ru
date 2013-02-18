require "rubygems"
require "bundler/setup"
require "sinatra"
require "sinatra_more/markup_plugin"
require "haml"

# Require all lib
Dir["./lib/*.rb"].each { |f| require f }

# Require all models
Dir["./models/*.rb"].each { |f| require f }

require "./app"

class Sinatra::Application
  register SinatraMore::MarkupPlugin
end

run Sinatra::Application
