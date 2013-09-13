# Public: The model that is used in the portfolio of the application.
class Project
  include DataMapper::Resource
  include Seedable

  property :id, Serial
  property :title, String, required: true, length: 255
  property :url, String, required: true
  property :body, Text, required: false
  property :image, String
  property :published, Boolean, required: true, default: true
  property :quote, String, length: 255
  property :created_at, DateTime
  property :updated_at, DateTime
  property :slug, String, length: 100

  # Public: Leverages the gem dm-is-sluggable to handle slugs.
  is :sluggable

  # Internal: Before creating a Project, we want to set the slug to the slugged
  # version of the title.
  before :create do
    set_slug(self.title.to_slug)
  end

  # Public: A scope that returns all Projects that have the Boolean published
  # set to true.
  #
  # Returns a DataMapper::Collection.
  def self.published
    all(published: true)
  end

end
