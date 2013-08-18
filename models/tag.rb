# Public: A Tag is a category that can be used to categorize another model.
class Tag
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, required: true

  # Public: Each Tag has many Taggings, which connect other models to Tags.
  has n, :taggings

  # Public: Each Tag has many Posts, which are connected through Taggings.
  has n, :posts, :through => :taggings
end

