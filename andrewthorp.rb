require "sinatra/base"
require "sinatra_more/markup_plugin"
require "./lib/helpers"

class AndrewThorp < Sinatra::Base
  register SinatraMore::MarkupPlugin
  helpers NavigationHelpers, AuthenticationHelpers, ViewHelpers
  enable :sessions
  set :session_secret, ENV["SESSION_SECRET"]

  get "/" do
    haml :index, layout: true
  end

  get "/login" do
    session[:return_to] = session[:return_to] || params[:return_to] || "/"
    haml :"sessions/new", layout: true
  end

  post "/sessions/create" do
    content_type :json

    if params[:password] == ENV["ADMIN_PASSWORD"]
      session[:current_user] = ENV["ADMIN_USERNAME"]
      { user: current_user, success: true, return: session.delete(:return_to) }.to_json
    else
      { success: false }.to_json
    end
  end

  get "/logout" do
    protected!("/")
    session.delete(:current_user)
    redirect "/"
  end

  get "/about" do
    haml :about, layout: true
  end

  get "/posts" do
    @page = (params[:page] || 1).to_i
    @per_page = (params[:per_page] || Post::PER_PAGE).to_i

    if params[:all]
      protected!
      @total_pages = Post.pages(@per_page)
      @posts = Post.all(order: [ :created_at.desc ]).page(@page, @per_page)
    else
      @total_pages = Post.pages(@per_page, published: true)
      @posts = Post.published.all(order: [ :created_at.desc ]).page(@page, @per_page)
    end

    haml :"posts/index", layout: true
  end

  get "/posts/tagged/:tag" do
    @page = (params[:page] || 1).to_i
    @per_page = (params[:per_page] || Post::PER_PAGE).to_i
    @tag = params[:tag]

    if params[:all]
      protected!
      @total_pages = Post.pages(@per_page, :query => :tagged_with, :query_args => @tag)
      @posts = Post.tagged_with(@tag, order: [ :created_at.desc ]).page(@page, @per_page)
    else
      @total_pages = Post.pages(@per_page, :query => :tagged_with, :query_args => @tag, :published => true)
      @posts = Post.published.tagged_with(@tag, order: [ :created_at.desc ]).page(@page, @per_page)
    end

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
    haml :portfolio, layout: true
  end

  get "/resume" do
    haml :resume, layout: true
  end

  # If everything went okay!
  run! if app_file == $0
end
