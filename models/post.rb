require "redcarpet"
require "faker"
require_relative "../lib/at_markdown_renderer"

class Post
  include DataMapper::Resource
  include Pagination
  include Taggable

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


  # Instance
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

