# Public: Everything that helps with navigation lives inside of this module.
#
# Examples
#
#   class AndrewThorp < Sinatra::Base
#     helpers NavigationHelper
#   end
module NavigationHelper

  # Public: Return an unordered list (ul) of social links.
  #
  # opts  - A Hash used to modify the result.
  #         :class - A String that is passed on and set as the class on the ul.
  #
  # Returns a String.
  def social_navigation(opts={})
    elems = []
    elems << content_tag(:li, link_to("&#xe006;", "http://www.twitter.com/andrewpthorp", class: "twitter", target: "_blank"))
    elems << content_tag(:li, link_to("&#xe004;", "http://www.facebook.com/andrewpthorp", class: "facebook", target: "_blank"))
    elems << content_tag(:li, link_to("&#xe02b;", "http://www.github.com/andrewpthorp", class: "github", target: "_blank"))
    content_tag :ul, elems.join, id: "social-nav", class: "group #{opts[:class]}"
  end

  # Public: Return the global navigation in an unordered list (ul).
  #
  # opts  - A Hash used to modify the result.
  #         :class - A String that is passed on and set as the class on the ul.
  #
  # Returns a String.
  def site_navigation(opts={})
    elems = []
    elems << content_tag(:li, link_to("", "/", class: "icon-home no-underline", title: "Home"))
    elems << content_tag(:li, link_to("", "/about", class: "icon-about no-underline", title: "About Me"))
    elems << content_tag(:li, link_to("", "/posts", class: "icon-blog no-underline", title: "Blog"))
    elems << content_tag(:li, link_to("", "/portfolio", class: "icon-portfolio no-underline", title: "Portfolio"))
    elems << content_tag(:li, link_to("", "/resume", class: "icon-resume no-underline", title: "Resume"))

    if user_signed_in?
      elems << content_tag(:li, link_to("", "/posts/new", class: "icon-plus no-underline", title: "New Post"))
      elems << content_tag(:li, link_to("", "/logout", class: "icon-logout no-underline", title: "Logout"), class: "gutter-bottom-none")
    else
      elems << content_tag(:li, link_to("", "/login?return_to=#{URI::encode(request.fullpath)}", class: "icon-login no-underline", title: "Login"), class: "gutter-bottom-none")
    end

    content_tag :ul, elems.join, id: "site-nav", class: "group #{opts[:class]}"
  end
end
