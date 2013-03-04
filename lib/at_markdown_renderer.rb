require "redcarpet"
require "coderay"

class ATMarkdownRenderer < Redcarpet::Render::HTML
  def block_code(code, language)
    CodeRay.highlight(code, language)
  end
end

