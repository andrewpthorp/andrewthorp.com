module TumblrHelpers
  def tumblr_list_view(post)
    pretty_date = DateTime.parse(post.date).strftime("%B, %d %Y")
    case post.type
    when "link", "chat", "text"
      elems = []
      elems << link_to(post.title, post.post_url)
      elems << content_tag(:span, pretty_date)
      content_tag :li, elems.join
    when "quote"
      elems = []
      elems << link_to(post.text, post.source_url)
      elems << content_tag(:span, pretty_date)
      content_tag :li, elems.join
    end
  end
end

helpers TumblrHelpers
