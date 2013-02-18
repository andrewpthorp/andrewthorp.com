module NavigationHelpers
  def social_navigation(opts={})
    elems = []
    elems << content_tag(:li, link_to("&#xe006;", "http://www.twitter.com/andrewpthorp", class: "twitter", target: "_blank"))
    elems << content_tag(:li, link_to("&#xe004;", "http://www.facebook.com/andrewpthorp", class: "facebook", target: "_blank"))
    elems << content_tag(:li, link_to("&#xe02b;", "http://www.github.com/andrewpthorp", class: "github", target: "_blank"))
    content_tag :ul, elems.join, id: "social-nav", class: "group #{opts[:class]}"
  end
end

module AuthenticationHelpers
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    return true unless production?

    # Using HTTP Basic Auth for production
    # TODO: Consider using another solution, not sure if this is secure enough.
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV["ADMIN_USERNAME"], ENV["ADMIN_PASSWORD"]]
  end
end
