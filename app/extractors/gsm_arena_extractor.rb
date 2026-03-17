
class GsmArenaExtractor < BaseExtractor
  def extract
    title = @doc.css('h1.article-info-name').first
    content = @doc.css('#review-body').first

    if content
      # Poda de lixo do GSMArena (redes sociais, navegação de páginas, comentários)
      trash_selectors = [
        '#social-share',
        '.article-pages',
        '.button-links',
        '#all-variants', # Às vezes aparece specs em news
        '.article-tags'
      ].join(', ')
      content.css(trash_selectors).remove
    end

    if title || content
      combined_html = "#{title}#{content}"
      clean_markdown(combined_html)
    else
      super
    end
  end
end
