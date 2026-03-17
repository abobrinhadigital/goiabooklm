
class XdaExtractor < BaseExtractor
  def extract
    title = @doc.css('h1.article-header-title').first
    content = @doc.css('.content-block-regular').first

    if title || content
      if content
        # Poda profunda de anúncios e lixo do XDA
        ad_selectors = [
          '.adsninja-injected-repeatable-ad-afterend',
          '.an-injected',
          '.adsninja-id-zone',
          '.an-btn-hide-me',
          '.dynamically-injected-refresh-ad-zone',
          '.ad-current',
          '.article-card'
        ].join(', ')

        content.css(ad_selectors).remove
      end
      combined_html = "#{title}#{content}"
      clean_markdown(combined_html)
    else
      super
    end
  end
end
