class Post
  include DataMapper::Resource

  property :id, Serial
  property :slug, String, required: true
  property :title, String, required: true, length: 255
  property :body, Text, required: true
  property :created_at, DateTime
  property :updated_at, DateTime
end
