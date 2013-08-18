require "redcarpet"
require "coderay"

# Public: A custom renderer on top of Redcarpet that I am using to include
# CodeRay into all of my markdown.
#
# Examples
#
#   renderer = ATMarkdownRenderer.new()
#   RedCarpet::Markdown.new(renderer, {}).render("**foo**")
#   # => "<p><strong>foo</strong></p>\n"
class ATMarkdownRenderer < Redcarpet::Render::HTML
  def block_code(code, language)
    CodeRay.highlight(code, language)
  end
end

