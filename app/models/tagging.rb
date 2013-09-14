# Public: A Tagging is the join table that sits between Tags and other models.
class Tagging
  include DataMapper::Resource

  property :id, Serial

  # Public: Each Tagging belongs to a Tag.
  belongs_to :tag

  # Public: Each Tagging belongs to a Post.
  belongs_to :post
end
