# TODO: This currently is only included in models/post.rb. I want to include
# this in models/project.rb when I take that off the ground.
module Seedable
  require 'faker'

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # Seed Data
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
          puts 'Create projects here.'
        end
      end
    end
  end

end
