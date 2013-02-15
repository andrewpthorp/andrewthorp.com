module NavigationHelpers
  def social_navigation(opts={})
    elems = []
    elems << content_tag(:li, link_to("&#xe006;", "http://www.twitter.com/andrewpthorp", class: "twitter", target: "_blank"))
    elems << content_tag(:li, link_to("&#xe004;", "http://www.facebook.com/andrewpthorp", class: "facebook", target: "_blank"))
    elems << content_tag(:li, link_to("&#xe02b;", "http://www.github.com/andrewpthorp", class: "github", target: "_blank"))
    content_tag :ul, elems.join, id: "social-nav", class: "group #{opts[:class]}"
  end
end

helpers NavigationHelpers
