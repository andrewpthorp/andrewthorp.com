get "/" do
  haml :index, layout: true
end

get "/about" do
  haml :about, layout: true
end

get "/blog" do
  @posts = Post.all
  haml :"posts/index", layout: true
end

get "/blog/new" do
  @post = Post.new
  haml :"posts/new", layout: true
end

post "/blog" do
  @post = Post.new(params[:post])
  if @post.save
    redirect "/blog"
  else
    haml :"posts/new", layout: true
  end
end

get "/blog/:slug/edit" do
  @post = Post.first(slug: params[:slug])
  haml :"posts/edit", layout: true
end

put "/blog/:slug" do
  @post = Post.first(slug: params[:slug])
  if @post.update(params[:post])
    redirect "/blog/#{params[:slug]}"
  else
    haml :"posts/edit", layout: true
  end
end

get "/blog/:slug" do
  @post = Post.first(slug: params[:slug])
  haml :"posts/show", layout: true
end

get "/portfolio" do
  haml :portfolio, layout: true
end

get "/resume" do
  haml :resume, layout: true
end
