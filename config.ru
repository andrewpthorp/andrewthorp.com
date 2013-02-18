require "rubygems"
require "bundler/setup"
require "sinatra"
require "sinatra_more/markup_plugin"
require "data_mapper"
require "dm-is-sluggable"
require "haml"

# Require all lib
Dir["./lib/*.rb"].each { |f| require f }

# Setup DataMapper Logger
DataMapper::Logger.new($stdout, :debug)

# Setup sqlite3 database
DataMapper::setup(:default, ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/andrewthorp-development.db")

# Require all models
Dir["./models/*.rb"].each { |f| require f }

# Finalize DataMapper
DataMapper.finalize

# Migrate Database
DataMapper.auto_upgrade!

require "./app"

class Sinatra::Application
  register SinatraMore::MarkupPlugin
end

run Sinatra::Application
