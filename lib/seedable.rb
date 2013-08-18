# TODO: Refactor this so I can handle posts and projects.
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
        Post.create(
          published: true,
          title: Faker::Lorem.sentence(5),
          body: Faker::Lorem.paragraphs(3, true).join("\n\n"),
          tag_list: tags.sample.join(",")
        )
      end
    end
  end

end
