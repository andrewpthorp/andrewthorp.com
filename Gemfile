source 'http://rubygems.org'
ruby '1.9.3'

gem 'sinatra'
gem 'sinatra_more'
gem 'bourbon'
gem 'sass'
gem 'haml'
gem 'thin'
gem 'heroku'
gem 'pg'
gem 'data_mapper'
gem 'dm-is-sluggable'
gem 'rdiscount'
gem 'json'
gem 'tux'
gem 'foreman'

group :production do
  gem 'dm-postgres-adapter'
end

group :development, :test do
  gem 'guard'
  gem 'guard-sass'
  gem 'guard-coffeescript'
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rerun'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'dm-sqlite-adapter'
end
