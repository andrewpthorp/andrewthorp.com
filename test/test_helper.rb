# test_helper.rb
ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/colorize'
require 'minitest/stub_const'
require 'mocha/setup'
require 'rack/test'
require 'data_mapper'
require 'dm-is-sluggable'
require 'dm-constraints'
require 'database_cleaner'
require 'shoulda/context'
require 'factory_girl'
require 'haml'
require 'sass'
require "emoji"

require_relative '../andrewthorp'

# DatabaseCleaner
DatabaseCleaner.strategy = :transaction

class MiniTest::Unit::TestCase
  extend Shoulda::Context::ClassMethods
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods

  def app
    AndrewThorp
  end

  def before_setup
    DatabaseCleaner.start
  end

  def after_teardown
    DatabaseCleaner.clean
  end
end

# Require all libraries
Dir["./lib/*.rb", "./models/*.rb", "./test/*.rb", "./test/factories/*.rb"].each { |f| require f }

# Setup sqlite3 database
DataMapper::setup(:default, "sqlite3::memory:")

# Finalize DataMapper
DataMapper.finalize

# Migrate Database
DataMapper.auto_upgrade!
