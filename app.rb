get "/" do
  haml :index, layout: true
end

get "/about" do
  haml :about, layout: true
end

get "/blog" do
  haml :blog, layout: true
end

get "/portfolio" do
  haml :portfolio, layout: true
end

get "/resume" do
  haml :resume, layout: true
end
