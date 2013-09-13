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
    elems << content_tag(:li, link_to('&#xe006;', 'http://www.twitter.com/andrewpthorp', class: 'twitter', target: '_blank'))
    elems << content_tag(:li, link_to('&#xe004;', 'http://www.facebook.com/andrewpthorp', class: 'facebook', target: '_blank'))
    elems << content_tag(:li, link_to('&#xe02b;', 'http://www.github.com/andrewpthorp', class: 'github', target: '_blank'))
    content_tag :ul, elems.join, id: 'social-nav', class: "group #{opts[:class]}"
  end

  # Public: Return the global navigation in an unordered list (ul).
  #
  # opts  - A Hash used to modify the result.
  #         :class - A String that is passed on and set as the class on the ul.
  #
  # Returns a String.
  def site_navigation(opts={})
    elems = []
    elems << content_tag(:li, link_to(' <span>Home</span>', '/', class: 'icon-home', title: 'Home'))
    elems << content_tag(:li, link_to(' <span>About</span>', '/about', class: 'icon-about', title: 'About Me'))
    elems << content_tag(:li, link_to(' <span>Blog</span>', '/posts', class: 'icon-blog', title: 'Blog'))
    elems << content_tag(:li, link_to(' <span>Portfolio</span>', '/portfolio', class: 'icon-portfolio', title: 'Portfolio'))
    elems << content_tag(:li, link_to(' <span>Resume</span>', '/resume', class: 'icon-resume', title: 'Resume'))

    if user_signed_in?
      elems << content_tag(:li, link_to(' <span>New Post</span>', '/posts/new', class: 'icon-plus', title: 'New Post'))
      elems << content_tag(:li, link_to(' <span>Log out</span>', '/logout', class: 'logout icon-logout', title: 'Logout'))
    else
      elems << content_tag(:li, link_to(' <span>Log in</span>', "/login?return_to=#{URI::encode(request.fullpath)}", class: 'login icon-login', title: 'Login'))
    end

    content_tag :ul, elems.join, id: 'site-nav', class: "group #{opts[:class]}"
  end
end
