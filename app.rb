get "/" do
  haml :index, layout: true
end

get "/about" do
  haml :about, layout: true
end

[ "/blog", "/posts" ].each do |path|
  get path do
    @posts = Post.all
    haml :"posts/index", layout: true
  end
end

[ "/blog/:slug", "/posts/:slug" ].each do |path|
  get path do
    @post = Post.first(slug: params[:slug])
    haml :"posts/show", layout: true
  end
end

get "/portfolio" do
  haml :portfolio, layout: true
end

get "/resume" do
  haml :resume, layout: true
end
