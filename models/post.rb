class Post
  include DataMapper::Resource

  property :id, Serial
  property :title, String, required: true
  property :body, Text, required: true
  property :created_at, DateTime
  property :updated_at, DateTime
end
