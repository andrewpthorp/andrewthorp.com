module TumblrHelpers
  def tumblr_list_view(post)
    pretty_date = DateTime.parse(post.date).strftime("%B, %d %Y")
    case post.type
    when "link", "chat", "text"
      elems = []
      elems << link_to(post.title, post.post_url, class: "title")
      elems << content_tag(:span, pretty_date)
      content_tag :li, elems.join, class: "group"
    when "quote"
      elems = []
      elems << link_to(post.text, post.source_url, class: "title")
      elems << content_tag(:span, pretty_date)
      content_tag :li, elems.join, class: "group"
    when "photo"
      elems = []
      elems << link_to(image_tag(post.photos[0].original_size.url), post.source_url, class: "image")
      elems << content_tag(:span, post.caption, class: "caption")
      content_tag :li, elems.join, class: "group"
    end
  end
end

module NavigationHelpers
  def desktop_navigation(action)
    elems = []
    elems << content_tag(:li, link_to("Resume", "/resume"), :class => action == 'resume' ? 'current' : '')
    elems << content_tag(:li, link_to("Blog", "/blog"), :class => action == 'blog' ? 'current' : '')
    elems << content_tag(:li, link_to("Portfolio", "/portfolio"), :class => action == 'portfolio' ? 'current': '')
    elems << content_tag(:li, link_to("About", "/about"), :class => action == 'about' ? 'current' : '')
    content_tag :ul, elems.join, :id => "global-nav", :class => "group"
  end

  def mobile_navigation(action)
    elems = []
    elems << content_tag(:li, link_to("About", "/about"))
    elems << content_tag(:li, link_to("Portfolio", "/portfolio"))
    elems << content_tag(:li, link_to("Blog", "/blog"))
    elems << content_tag(:li, link_to("Resume", "/resume"))
    content_tag :ul, elems.join, :id => "mobile-nav", :class => "show-on-phones"
  end
end

helpers TumblrHelpers, NavigationHelpers
