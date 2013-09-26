# Public: This module allows me to seed the database with sample data for the
# given models.
#
# TODO: Figure out if I want to move this into a rake task and get rid of this
# module altogether. It probably doesn't make sense to have strictly development
# dependencies anywhere inside of the models.
#
# Examples
#
#   class Post
#     include Seedable
#   end
module Seedable
  require 'faker'

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # Public: Seed the database with development data. This method simply
    # returns nil if we are not in development.
    #
    # num - The number of instances to seed the database with (default: 100).
    #
    # Returns nothing.
    def seed(num=100)
      return unless development?

      case ancestors.first.name
      when 'Post'
        tags = [["sports"], ["the-changelog"], ["personal"], ["development"]]
        1.upto(num) do
          Post.create(published: true, title: Faker::Lorem.sentence(5),
                      body: Faker::Lorem.paragraphs(3, true).join("\n\n"),
                      tag_list: tags.sample.join(","))
        end
      when 'Project'
        [
          {
            title: 'RubyGem - ESPN', url: 'http://github.com/andrewpthorp/espn',
            image: '', body: "ESPN has a pretty awesome API, but I couldn't find a simple way to digest it in a ruby application. I built a RubyGem that wraps the API so you can pull their information into your websites, command line apps, etc."
          },
          {
            title: 'Tushies &amp; Tantrums', url: 'http://tushiesandtantrums.com',
            image: 'tushiesandtantrums.png', body: 'Rails app with SASS, HAML, and Coffeescript. Using Foundation.',
            published: false
          },
          {
            title: 'Pure Charity', url: 'http://purecharity.com',
            image: 'purecharity.png', body: 'Rails app with SASS, HAML, and CoffeeSCript.'
          },
          {
            title: 'Ace of Sales', url: 'http://aceofsales.com',
            image: 'aceofsales.png', body: 'Rails app with SASS, ERB, and CoffeeScript.'
          },
          {
            title: 'Tushies &amp; Tantrums', url: 'http://tushi.es',
            image: 'tushies.jpg', body: 'Rails app with SASS, HAML, and CoffeeScript. Using Foundation and Stripe.'
          },
          {
            title: "Daniel Keeton's Website", url: 'http://danielkeeton.com',
            image: 'danielkeeton.png', body: 'Rails app with SASS, HAML, and CoffeeScript. Using Foundation.'
          },
          {
            title: 'Wists', url: 'http://wists.andrewthorp.com',
            image: 'wists.png', body: 'Rails app with SASS, HAML and CoffeeScript.'
          },
          {
            title: 'My Personal Website', url: 'http://andrewthorp.com',
            image: 'andrewthorp.png', body: 'Sinatra app with SASS, HAML, and CoffeeScript.'
          }
        ].each do |p|
          p[:published] = true if p[:published].nil?
          Project.create(title: p[:title], body: p[:body], url: p[:url],
                         image: p[:image], published: p[:published])
        end
      end
    end
  end

end
