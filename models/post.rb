class Post
  include DataMapper::Resource
  include Taggable
  include Seedable
  include Pageable

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

end
