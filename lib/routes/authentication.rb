# Public: The authentication routes are handled in this class.
class AndrewThorp < Sinatra::Base

  # Public: The route that someone has to go to in order to login to the
  # website and perform Admin actions. These include, but are not limited to,
  # creating/editing Posts and Projects.
  get "/login" do
    set_return_to(params[:return_to] || '/') if return_to.nil?
    haml :"sessions/new", layout: true
  end

  # Public: When someone fills out the login form, the data is sent with a POST
  # and handled in this method.
  post "/sessions/create" do
    content_type :json
    auth_user_from_env if valid_password?(params[:password])
    auth_result_hash.to_json
  end

  get "/logout" do
    protected!("/")
    session.delete(:current_user)
    redirect "/"
  end

end
