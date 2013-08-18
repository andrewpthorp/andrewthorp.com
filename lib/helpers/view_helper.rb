module ViewHelper
  def emojify(content)
    content.to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
      if Emoji.names.include?($1)
        "<img alt='#{$1}' src='/images/emoji/#{$1}.png' class='emoji' />"
      else
        match
      end
    end
  end

  def classify(post)
    case post.tags.first.name
    when 'sports'
      emoji = ':baseball:'
    when 'the-changelog', 'development'
      emoji = ':computer:'
    when 'personal'
      emoji = ':beers:'
    end

    emojify(emoji)
  end
end
