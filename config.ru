require "rubygems"
require "bundler/setup"
require "sinatra"
require "sinatra_more/markup_plugin"
require "haml"

require "./app"

class Sinatra::Application
  register SinatraMore::MarkupPlugin
end

run Sinatra::Application
