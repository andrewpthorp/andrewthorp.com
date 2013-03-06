require "redcarpet"
require_relative "../lib/at_markdown_renderer"

class Post
  include DataMapper::Resource

  # Class Variables
  PER_PAGE = 10

  # Properties
  property :id, Serial
  property :title, String, required: true, length: 255
  property :body, Text, required: true
  property :published, Boolean, required: true, default: false
  property :created_at, DateTime
  property :updated_at, DateTime
  property :slug, String, length: 100
  is :sluggable

  # Associations
  has n, :taggings
  has n, :tags, :through => :taggings

  # Hooks
  before :create do
    set_slug(self.title.to_slug)
  end

  before :destroy do
    taggings.destroy unless !saved?
  end

  # Scopes
  def self.published
    all(published: true)
  end

  def self.tagged_with(string, options = {})
    tag = Tag.first(name: string)
    conditions = {
      'taggings.tag_id' => tag.kind_of?(Tag) ? tag.id : nil
    }
    all(conditions.update(options))
  end

  # Class Methods
  def self.pages
    return 1 if count < PER_PAGE

    (count / PER_PAGE)
  end

  # Instance Methods
  def self.page(page = 1, per_page = PER_PAGE)
    page = 1 if page.nil?
    page = page.to_i unless page.is_a? Integer

    offset = (page - 1) * per_page
    all[offset, per_page]
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
    rndr = ATMarkdownRenderer.new(filter_html: true, hard_wrap: true)
    options = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      strikethrough: true,
      lax_html_blocks: true,
      superscript: true
    }
    markdown_to_html = Redcarpet::Markdown.new(rndr, options)
    markdown_to_html.render(self.body)
  end
end

