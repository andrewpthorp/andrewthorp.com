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

      tags = [["sports"], ["the-changelog"], ["personal"], ["development"]]

      1.upto(num) do
        case ancestors.first.name
        when 'Post'
          Post.create(published: true, title: Faker::Lorem.sentence(5),
                      body: Faker::Lorem.paragraphs(3, true).join("\n\n"),
                      tag_list: tags.sample.join(","))
        when 'Project'
          Project.create(title: Faker::Lorem.sentence(2),
                         body: Faker::Lorem.paragraph(3),
                         quote: Faker::Lorem.sentence(4),
                         url: 'http://google.com', image: 'andrewthorp.png')
        end
      end
    end
  end

end
