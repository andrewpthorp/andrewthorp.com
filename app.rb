require_relative 'initializers' if File.exists? './initializers.rb'
require_relative 'helpers' if File.exists? './helpers.rb'

get "/" do
  redirect "/about"
end

get "/about" do
  erb :about, :locals => { action: "about", title: "A BROKEN MAN" }
end

get "/portfolio" do
  erb :portfolio, :locals => { action: "portfolio", title: "PLAYGROUND" }
end

get "/blog" do
  posts = TumblRb.posts("andrewpthorp").posts
  erb :blog, :locals => { action: "blog", title: "PIXEL LOG", posts: posts }
end

get "/resume" do
  erb :resume, :locals => { action: "resume", title: "DON'T BE CREEPY" }
end
