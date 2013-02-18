require 'rdiscount'

class Post
  include DataMapper::Resource
  is :sluggable

  property :id, Serial
  property :slug, String
  property :title, String, required: true, length: 255
  property :body, Text, required: true
  property :created_at, DateTime
  property :updated_at, DateTime

  before :create do
    set_slug(self.title.to_slug)
  end

  def pretty_body
    RDiscount.new(self.body, :autolink).to_html
  end
end
