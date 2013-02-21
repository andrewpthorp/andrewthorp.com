require "sinatra/base"
require "sinatra_more/markup_plugin"
require "./lib/helpers"

class AndrewThorp < Sinatra::Base
  register SinatraMore::MarkupPlugin
  helpers NavigationHelpers, AuthenticationHelpers
  enable :sessions

  get "/" do
    haml :index, layout: true
  end

  get "/login" do
    protected!
    redirect "/"
  end

  get "/about" do
    protected!("This feature is still in development")
    haml :about, layout: true
  end

  get "/blog" do
    if params[:all]
      protected!
      @posts = Post.all(order: [ :created_at.desc ])
    else
      @posts = Post.published.all(order: [ :created_at.desc ])
    end

    haml :"posts/index", layout: true
  end

  get "/blog/tagged/:tag" do
    if params[:all]
      protected!
      @posts = Post.tagged_with(params[:tag], order: [ :created_at.desc ])
    else
      @posts = Post.published.tagged_with(params[:tag], order: [ :created_at.desc ])
    end

    @tag = params[:tag]

    haml :"posts/index", layout: true
  end

  get "/blog/new" do
    protected!
    @post = Post.new
    erb :"posts/new", layout: true, layout_engine: :haml
  end

  post "/blog" do
    protected!
    @post = Post.new(params[:post])
    if @post.save
      redirect "/blog/#{@post.slug}"
    else
      erb :"posts/new", layout: true, layout_engine: :haml
    end
  end

  get "/blog/:slug/edit" do
    protected!
    @post = Post.first(slug: params[:slug])
    erb :"posts/edit", layout: true, layout_engine: :haml
  end

  get "/blog/:slug/delete" do
    protected!
    @post = Post.first(slug: params[:slug])
    if @post.destroy
      redirect "/blog"
    else
      redirect "/blog/#{@post.slug}"
    end
  end

  put "/blog/:slug" do
    protected!
    @post = Post.first(slug: params[:slug])
    if @post.update(params[:post])
      redirect "/blog/#{params[:slug]}"
    else
      erb :"posts/edit", layout: true, layout_engine: :haml
    end
  end

  get "/blog/:slug" do
    @post = Post.first(slug: params[:slug])
    haml :"posts/show", layout: true
  end

  get "/portfolio" do
    protected!("This feature is still in development")
    haml :portfolio, layout: true
  end

  get "/resume" do
    protected!("This feature is still in development")
    haml :resume, layout: true
  end

  # If everything went okay!
  run! if app_file == $0
end
