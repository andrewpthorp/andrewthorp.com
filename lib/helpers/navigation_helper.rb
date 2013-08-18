module NavigationHelper
  def social_navigation(opts={})
    elems = []
    elems << content_tag(:li, link_to("&#xe006;", "http://www.twitter.com/andrewpthorp", class: "twitter", target: "_blank"))
    elems << content_tag(:li, link_to("&#xe004;", "http://www.facebook.com/andrewpthorp", class: "facebook", target: "_blank"))
    elems << content_tag(:li, link_to("&#xe02b;", "http://www.github.com/andrewpthorp", class: "github", target: "_blank"))
    content_tag :ul, elems.join, id: "social-nav", class: "group #{opts[:class]}"
  end

  def site_navigation(opts={})
    elems = []
    elems << content_tag(:li, link_to("", "/", class: "icon-home no-underline", title: "Home"))
    elems << content_tag(:li, link_to("", "/about", class: "icon-about no-underline", title: "About Me"))
    elems << content_tag(:li, link_to("", "/posts", class: "icon-blog no-underline", title: "Blog"))
    elems << content_tag(:li, link_to("", "/portfolio", class: "icon-portfolio no-underline", title: "Portfolio"))
    elems << content_tag(:li, link_to("", "/resume", class: "icon-resume no-underline", title: "Resume"))

    if current_user
      elems << content_tag(:li, link_to("", "/posts/new", class: "icon-plus no-underline", title: "New Post"))
      elems << content_tag(:li, link_to("", "/logout", class: "icon-logout no-underline", title: "Logout"), class: "gutter-bottom-none")
    else
      elems << content_tag(:li, link_to("", "/login?return_to=#{URI::encode(request.fullpath)}", class: "icon-login no-underline", title: "Login"), class: "gutter-bottom-none")
    end

    content_tag :ul, elems.join, id: "site-nav", class: "group #{opts[:class]}"
  end
end
