require 'readability'
require 'reverse_markdown'
require 'nokogiri'

class BaseExtractor
def initialize(url, html)
  @url = url
  @html = html
  @doc = Nokogiri::HTML(html)
end

def extract
  # Default strategy: use Readability unless overridden
  readability_doc = Readability::Document.new(@html, tags: %w[div p h1 h2 h3 h4 h5 h6 ul ol li strong em pre code blockquote img a])
  clean_html = readability_doc.content
  ReverseMarkdown.convert(clean_html, github_flavored: true)
end

private

  def clean_markdown(html_fragment)
    ReverseMarkdown.convert(html_fragment.to_s, github_flavored: true)
  end
end
