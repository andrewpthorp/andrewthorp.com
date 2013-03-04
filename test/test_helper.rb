# test_helper.rb
ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/colorize'
require 'mocha/setup'
require 'rack/test'
require 'data_mapper'
require 'dm-is-sluggable'
require 'database_cleaner'
require 'shoulda-context'
require 'factory_girl'

require_relative '../andrewthorp'

# Setup sqlite3 database
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/andrewthorp-test.db")

# Require all models
Dir["./models/*.rb"].each { |f| require f }

# Require all factories
Dir["./test/factories/*.rb"].each { |f| require f }

# Finalize DataMapper
DataMapper.finalize

# Migrate Database
DataMapper.auto_upgrade!

class MiniTest::Unit::TestCase
  extend Shoulda::Context::ClassMethods
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods

  def app
    AndrewThorp
  end
end

# DatabaseCleaner
DatabaseCleaner.strategy = :transaction
MiniTest::Unit::TestCase.add_setup_hook { DatabaseCleaner.start }
MiniTest::Unit::TestCase.add_teardown_hook { DatabaseCleaner.clean }
