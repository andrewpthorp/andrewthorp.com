require "sinatra/base"
require "sinatra_more/markup_plugin"
require "./lib/helpers"

class AndrewThorp < Sinatra::Base
  register SinatraMore::MarkupPlugin
  helpers NavigationHelpers, AuthenticationHelpers

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
    haml :portfolio, layout: true
  end

  get "/resume" do
    haml :resume, layout: true
  end

  # If everything went okay!
  run! if app_file == $0
end