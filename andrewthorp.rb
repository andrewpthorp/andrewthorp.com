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

  get "/logout" do
    session.delete(:admin)
    redirect "/"
  end

  get "/about" do
    protected!("This feature is still in development")
    haml :about, layout: true
  end

  get "/posts" do
    if params[:all]
      protected!
      @posts = Post.all(order: [ :created_at.desc ])
    else
      @posts = Post.published.all(order: [ :created_at.desc ])
    end

    haml :"posts/index", layout: true
  end

  get "/posts/tagged/:tag" do
    if params[:all]
      protected!
      @posts = Post.tagged_with(params[:tag], order: [ :created_at.desc ])
    else
      @posts = Post.published.tagged_with(params[:tag], order: [ :created_at.desc ])
    end

    @tag = params[:tag]

    haml :"posts/index", layout: true
  end

  get "/posts/new" do
    protected!
    @post = Post.new
    haml :"posts/new", layout: true
  end

  post "/posts" do
    protected!
    @post = Post.new(params[:post])
    if @post.save
      redirect "/posts/#{@post.slug}"
    else
      haml :"posts/new", layout: true
    end
  end

  get "/posts/:slug/edit" do
    protected!
    @post = Post.first(slug: params[:slug])
    haml :"posts/edit", layout: true
  end

  get "/posts/:slug/delete" do
    protected!
    @post = Post.first(slug: params[:slug])
    if @post.destroy
      redirect "/posts"
    else
      redirect "/posts/#{@post.slug}"
    end
  end

  put "/posts/:slug" do
    protected!
    @post = Post.first(slug: params[:slug])
    if @post.update(params[:post])
      redirect "/posts/#{params[:slug]}"
    else
      haml :"posts/edit", layout: true
    end
  end

  get "/posts/:slug" do
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
