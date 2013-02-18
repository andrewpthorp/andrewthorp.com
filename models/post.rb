class Post
  include DataMapper::Resource
  is :sluggable

  property :id, Serial
  property :slug, String
  property :title, String, required: true, length: 255
  property :body, Text, required: true
  property :created_at, DateTime
  property :updated_at, DateTime
end
