class AndrewThorp < Sinatra::Base

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

end
