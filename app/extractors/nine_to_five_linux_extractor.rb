
class NineToFiveLinuxExtractor < BaseExtractor
  def extract
    title = @doc.css('h1.entry-title').first
    subtitle = @doc.css('div.bm-post-subtitle').first
    content = @doc.css('div.entry-content').first

    if content
      # Removemos o lixo interno (Related Posts e Sponsors) antes de converter para Markdown
      content.css('#jp-relatedposts, .sponsor-block-1').remove
    end

    if title || subtitle || content
      combined_html = "#{title}#{subtitle}#{content}"
      clean_markdown(combined_html)
    else
      super
    end
  end
end
