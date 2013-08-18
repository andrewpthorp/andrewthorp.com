module AuthenticationHelper
  def current_user
    session[:current_user]
  end

  def user_signed_in?
    !session[:current_user].nil?
  end

  def protected!(failure_path="/login")
    unless current_user
      session[:return_to] = request.fullpath
      redirect failure_path
    end
  end

  def production?
    ENV["RACK_ENV"] == "production"
  end
end
