
class TecnoblogExtractor < BaseExtractor
  def extract
    title = @doc.css('h1.title').first
    subtitle = @doc.css('p.olho').first
    content = @doc.css('.entry').first

    if content
      # Remoção de lixo e anúncios do Tecnoblog
      trash_selectors = [
        '.tb-ad-discrete-container',
        '#tb-banner-google',
        'nav.tags'
      ].join(', ')
      content.css(trash_selectors).remove
    end

    if title || subtitle || content
      combined_html = "#{title}#{subtitle}#{content}"
      clean_markdown(combined_html)
    else
      super
    end
  end
end
