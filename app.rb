require_relative 'initializers' if File.exists? './initializers.rb'
require_relative 'helpers' if File.exists? './helpers.rb'

get "/" do
  haml :index, :layout => :layout
end
