require "sinatra/base"
require "sinatra_more/markup_plugin"
require "./lib/helpers"

class AndrewThorp < Sinatra::Base
  register SinatraMore::MarkupPlugin
  helpers NavigationHelpers, AuthenticationHelpers, ViewHelpers
  enable :sessions

  get "/" do
    haml :index, layout: true
  end

  get "/login" do
    haml :"sessions/new", layout: true
  end

  post "/sessions/create" do
    content_type :json

    if params[:password] == ENV["ADMIN_PASSWORD"]
      session[:current_user] = ENV["ADMIN_USERNAME"]
      { user: current_user, success: true }.to_json
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
    @total_pages = Post.pages(@per_page)

    if params[:all]
      protected!
      @posts = Post.all(order: [ :created_at.desc ]).page(@page, @per_page)
    else
      @posts = Post.published.all(order: [ :created_at.desc ]).page(@page, @per_page)
    end

    haml :"posts/index", layout: true
  end

  get "/posts/tagged/:tag" do
    @page = (params[:page] || 1).to_i
    @per_page = (params[:per_page] || Post::PER_PAGE).to_i
    @total_pages = Post.pages(@per_page)

    if params[:all]
      protected!
      @posts = Post.tagged_with(params[:tag], order: [ :created_at.desc ]).page(@page, @per_page)
    else
      @posts = Post.published.tagged_with(params[:tag], order: [ :created_at.desc ]).page(@page, @per_page)
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
    haml :portfolio, layout: true
  end

  get "/resume" do
    haml :resume, layout: true
  end

  # If everything went okay!
  run! if app_file == $0
end
