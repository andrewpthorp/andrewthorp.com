require "redcarpet"
require "faker"
require_relative "../lib/at_markdown_renderer"

class Post
  include DataMapper::Resource

  # Class Variables
  PER_PAGE = 25

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

  # Get all published Posts
  def self.published
    all(published: true)
  end

  # Get all Posts tagged with a string
  def self.tagged_with(string, options = {})
    tag = Tag.first(name: string)
    conditions = {
      'taggings.tag_id' => tag.kind_of?(Tag) ? tag.id : nil
    }
    all(conditions.update(options))
  end

  # Query for the total number of pages.
  def self.pages(per_page = PER_PAGE, opts={})
    if opts[:published]
      query = Post.published
    else
      query = Post
    end

    if !opts[:query] || opts[:query] == :all
      c = query.count
    elsif opts[:query_args].blank?
      c = query.send(opts[:query]).count
    else
      c = query.send(opts[:query], opts[:query_args]).count
    end

    return 1 if c < per_page
    (c.to_f / per_page).ceil
  end

  # Query for a specific page.
  def self.page(page = 1, per_page = PER_PAGE)
    page = 1 if page.nil?
    page = page.to_i unless page.is_a? Integer

    offset = (page - 1) * per_page
    all[offset, per_page]
  end

  # Get tag_list for a specific instance.
  def tag_collection
    @tag_collection ||= tags.map(&:name)
  end

  # Set tag_list on a specific instance.
  def tag_list=(string)
    @tag_collection = string.to_s.split(',').map { |name| name.strip }.uniq.sort
    update_tags
  end

  # Helper for HTML forms.
  def tag_list
    tags.map { |tag| tag.name }.join(', ')
  end

  # This actually sets the tags prior to saving an instance.
  def update_tags
    self.tags = tag_collection.map { |name| Tag.first_or_new(name: name) }
  end

  # Get the Markdown/CodeRay rendered body
  def pretty_body
    rndr = ATMarkdownRenderer.new(filter_html: false, hard_wrap: true)
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

    tags = [["sports"], ["the-changelog"], ["personal"], ["development"]]

    1.upto(num) do
      Post.create(
        published: true,
        title: Faker::Lorem.sentence(5),
        body: Faker::Lorem.paragraphs(3, true).join("\n\n"),
        tag_list: tags.sample.join(",")
      )
    end
  end
end

