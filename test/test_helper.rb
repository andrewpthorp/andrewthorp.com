# test_helper.rb
ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'data_mapper'
require 'dm-is-sluggable'
require 'database_cleaner'

require_relative '../andrewthorp'

# Setup sqlite3 database
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/andrewthorp-test.db")

# Require all models
Dir["./models/*.rb"].each { |f| require f }

# Finalize DataMapper
DataMapper.finalize

# Migrate Database
DataMapper.auto_upgrade!

class MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    AndrewThorp
  end
end

# DatabaseCleaner
DatabaseCleaner.strategy = :transaction
MiniTest::Unit::TestCase.add_setup_hook { DatabaseCleaner.start }
MiniTest::Unit::TestCase.add_teardown_hook { DatabaseCleaner.clean }

unless ENV["DISABLE_TURN"]
  require 'turn'
  Turn.config do |c|
   # use one of output formats:
   # :outline  - turn's original case/test outline mode [default]
   # :progress - indicates progress with progress bar
   # :dotted   - test/unit's traditional dot-progress mode
   # :pretty   - new pretty reporter
   # :marshal  - dump output as YAML (normal run mode only)
   # :cue      - interactive testing
   c.format  = :pretty
   # turn on invoke/execute tracing, enable full backtrace
   c.trace   = true
   # use humanized test names (works only with :outline format)
   # c.natural = true
  end
end
