require 'rubygems'
require 'bundler/setup'
require 'data_mapper'

# Enable '_method' override hack in HTML forms.
use Rack::MethodOverride

# Setup DataMapper Logger
DataMapper::Logger.new($stdout, :debug)

# Setup sqlite3 database
DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/andrewthorp-development.db")

# Finalize DataMapper
DataMapper.finalize

# Migrate Database
DataMapper.auto_upgrade!

# Require and run!
require './andrewthorp'
run AndrewThorp
