require_relative 'initializers'
require_relative 'helpers'

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
