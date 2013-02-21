require 'rdiscount'

class Post
  include DataMapper::Resource
  is :sluggable

  property :id, Serial
  property :slug, String, length: 100
  property :title, String, required: true, length: 255
  property :body, Text, required: true
  property :published, Boolean, required: true, default: false
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :taggings
  has n, :tags, :through => :taggings

  before :create do
    set_slug(self.title.to_slug)
  end

  before :destroy do
    taggings.destroy
  end

  def self.published
    all(published: true)
  end

  def self.tagged_with(string, options = {})
    tag = Tag.first(:name => string)
    conditions = {
      'taggings.tag_id' => tag.kind_of?(Tag) ? tag.id : nil
    }
    all(conditions.update(options))
  end

  def tag_list
    @tag_list ||= tags.map do |tag|
      tag.name
    end
  end

  def tag_list=(string)
    @tag_list = string.to_s.split(',').map { |name| name.strip }.uniq.sort
    update_tags
  end

  def tag_collection
    tags.map { |tag| tag.name }.join(', ')
  end

  def update_tags
    self.tags = tag_list.map { |name| Tag.first_or_new(name: name) }
  end

  def pretty_body
    RDiscount.new(self.body, :autolink, :smart).to_html
  end
end

class Tag
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, required: true

  has n, :taggings
  has n, :posts, :through => :taggings
end

class Tagging
  include DataMapper::Resource

  property :id, Serial

  belongs_to :tag
  belongs_to :post
end
