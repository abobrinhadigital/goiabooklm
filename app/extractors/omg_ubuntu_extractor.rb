
class OmgUbuntuExtractor < BaseExtractor
  def extract
    title = @doc.css('h1.post-title, h1').first
    content = @doc.css('.post-content').first

    if content
      # Poda de lixo do OMG! Ubuntu! (meta, bio, populares, comentários)
      trash_selectors = [
        '.post-meta',
        '.MostPopular',
        '.disqus-widget',
        '.omg-hero-button',
        '.omg-social-proof',
        '.post-actions',
        '.post-author-bio',
        '#disqus_thread'
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
