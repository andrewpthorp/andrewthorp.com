# Public: Everything that helps with view lives inside of this module. This
# includes emoji.
#
# TODO: Should I combine this and NavigationHelper, since they are the both
# generating HTML for the view?
#
# Examples
#
#   class AndrewThorp < Sinatra::Base
#     helpers ViewHelper
#   end
module ViewHelper

  # Public: Searches a String for emoji characters wrapped in colons. If it
  # finds any matches, it replaces them with an image tag for that emoji. If it
  # finds matches, but the emoji doesn't exist, it leaves it untouched.
  #
  # text - The String to replace all :emoji: characters in.
  #
  # Examples
  #
  #   emojify('Totally :+1:')
  #   # => 'Totally <img alt='+1' src='/images/emoji/+1.png' class='emoji' />.'
  #   emojify('Totally :somerandomthingnotemoji:')
  #   # => 'Totally :somerandomthingnotemoji:'
  #
  # Returns a String.
  def emojify(text)
    text.to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
      if Emoji.names.include?($1)
        "<img alt='#{$1}' src='/images/emoji/#{$1}.png' class='emoji' />"
      else
        match
      end
    end
  end

  # Public: Takes a model that has Tags, and it gets the emoji name that I have
  # set up for that class. It then calls the emojify method and returns it's
  # result.
  #
  # model - The instance of a model (Post or Project) that has Tags.
  #
  # Examples
  #
  #   # Assuming post is a Post with the tags ['personal', 'sports']
  #   classify(post)
  #   # => '<img alt='beers' src='/images/emoji/beers.png' class='emoji' />'
  #
  # Returns a String.
  def classify(model)
    case model.tags.first.name
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
