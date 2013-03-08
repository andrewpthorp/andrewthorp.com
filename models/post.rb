require "redcarpet"
require "faker"
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
  has n, :taggings, :constraint => :destroy
  has n, :tags, :through => :taggings

  # Hooks
  before :create do
    set_slug(self.title.to_slug)
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
  def self.pages(per_page = PER_PAGE)
    return 1 if count < per_page
    (count.to_f / per_page).ceil
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

  # Seed Data
  def self.seed(num=100)
    return unless development?

    tags = [["the-changelog", "development"],
            ["sports"], ["the-changelog"], ["development"]]

    1.upto(num) do
      Post.create(
        published: true,
        title: Faker::Lorem.sentence(10),
        body: Faker::Lorem.paragraphs(3, true).join("\n\n"),
        tag_list: tags.sample.join(",")
      )
    end
  end
end

