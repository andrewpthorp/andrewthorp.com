# Public: The model that is used in the blog of the application.
class Post
  include DataMapper::Resource
  include Taggable
  include Seedable
  include Pageable

  # Public: Integer that controls how many to display per page in the blog.
  PER_PAGE = 25

  property :id, Serial
  property :title, String, required: true, length: 255
  property :body, Text, required: true
  property :published, Boolean, required: true, default: false
  property :created_at, DateTime
  property :updated_at, DateTime
  property :slug, String, length: 100

  # Public: Leverages the gem dm-is-sluggable to handle slugs.
  is :sluggable

  # Public: Each Post has many Taggings, which control the relationship between
  # Posts and Tags.
  has n, :taggings, :constraint => :destroy

  # Public: Each Post has many Tags, through Taggings.
  has n, :tags, :through => :taggings

  # Public: Before creating a Post, we want to set the slug to the slugged
  # version of the title.
  before :create do
    set_slug(self.title.to_slug)
  end

  # Public: A scope that returns all Posts that have the Boolean published
  # set to true.
  #
  # Returns a DataMapper::Collection.
  def self.published
    all(published: true)
  end

  # Public: Use our custom renderer ATMarkdownRenderer to get the body of
  # a Post instance in an HTML friendly format.
  #
  # Returns a String.
  def markdown_body
    renderer = ATMarkdownRenderer.new(filter_html: false, hard_wrap: true)
    options = { fenced_code_blocks: true, no_intra_emphasis: true,
                autolink: true, strikethrough: true, lax_html_blocks: true,
                superscript: true }
    Redcarpet::Markdown.new(renderer, options).render(self.body)
  end

end
