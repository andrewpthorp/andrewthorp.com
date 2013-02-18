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

  # TODO: Move this into a DataMapper hook.
  # They weren't being called during development,
  # not sure why.
  @post.set_slug(@post.title.to_slug)

  if @post.save!
    redirect "/blog"
  else
    haml :"posts/new", layout: true
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
