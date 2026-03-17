
class ItsFossExtractor < BaseExtractor
  def extract
    title = @doc.css('h1.post-hero__title').first
    subtitle = @doc.css('div.post-hero__excerpt').first
    content = @doc.css('article.post').first

    if content
      # Removemos lixo específico (elementos escondidos no mobile e cards de CTA)
      content.css('.hide-mobile, .kg-cta-card').remove
    end

    if title || subtitle || content
      combined_html = "#{title}#{subtitle}#{content}"
      clean_markdown(combined_html)
    else
      super
    end
  end
end
