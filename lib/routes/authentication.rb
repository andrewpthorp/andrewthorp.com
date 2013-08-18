# Public: The authentication routes are handled in this class.
class AndrewThorp < Sinatra::Base

  # Public: The route that someone has to go to in order to login to the
  # website and perform Admin actions. These include, but are not limited to,
  # creating/editing Posts and Projects.
  get "/login" do
    session[:return_to] = session[:return_to] || params[:return_to] || "/"
    haml :"sessions/new", layout: true
  end

  # Public: When someone fills out the login form, the data is sent with a POST
  # and handled in this method.
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
