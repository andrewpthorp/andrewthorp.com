class Post
  include DataMapper::Resource
  include Taggable
  include Seedable

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
