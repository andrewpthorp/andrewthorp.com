# Public: Everything that helps with authentication will live inside of this
# module. That includes current_user, protecting routes, production check, etc.
#
# Examples
#
#   class AndrewThorp < Sinatra::Base
#     helpers AuthenticationHelper
#   end
module AuthenticationHelper

  # Public: Set the current user in the session. This happens after the user
  # has logged in.
  #
  # TODO: Figure out why :current_user= doesn't work.
  #
  # username - The username of the person who is logging in.
  #
  # Returns nothing.
  def set_current_user(username)
    session[:current_user] = username
  end

  # Public: Return the current user. This is stored in the session. If the
  # user has not logged in, it will return nil.
  #
  # Returns nil or a String of the username.
  def current_user
    session[:current_user]
  end

  # Public: Return whether or not there is a user signed in. This is simply a
  # Boolean helper method that checks if there is a current_user stored in the
  # session.
  #
  # Returns a Boolean.
  def user_signed_in?
    !session[:current_user].nil?
  end

  # Public: Set the user in the session from the ENV.
  #
  # Returns nothing.
  def auth_user_from_env
    set_current_user(ENV['ADMIN_USERNAME'])
  end

  # Public: Returns the Hash that lets us know if the authentication was
  # successful or not. If the authentication was successful, It will have
  # success set to true (along with soem other fields). If the authentication
  # was a failure, it will have success set to false (ant nothing else).
  #
  # Returns a Hash.
  def auth_result_hash
    if user_signed_in?
      { success: true, user: current_user, return: return_to(true) }
    else
      { success: false }
    end
  end

  # Public: Check if the submitted password is valid.
  #
  # password - The submitted String to check against the ENV password variable.
  #
  # Returns a Boolean.
  def valid_password?(password)
    password == ENV['ADMIN_PASSWORD']
  end

  # Public: Set the URL that we will return_to after signing a user in.
  #
  # TODO: Figure out why :return_to= does not work.
  #
  # url - The url to that we wnt to redirect the user back to after a succesful
  #       sign in (default: '/').
  #
  # Returns nothing.
  def set_return_to(url='/')
    session[:return_to] = url
  end

  # Public: Get the URL that we will return the user to after signing in.
  #
  # delete - Whether to delete the value from the session (default: false).
  #
  # Returns a String.
  def return_to(delete=false)
    return session.delete(:return_to) if delete
    session[:return_to]
  end

  # Public: Used to protect a route. If there is no user signed in, this will
  # set the return_to and redirect them to the failure_path.
  #
  # failure_path - The URL to redirect logged out users to (default: '/login').
  #
  # Returns nothing.
  def protected!(failure_path='/login')
    unless user_signed_in?
      session[:return_to] = request.fullpath
      redirect failure_path
    end
  end

  # Public: Used to determine whether the application is running in production.
  #
  # Returns a Boolean.
  def production?
    ENV['RACK_ENV'] == 'production'
  end
end
