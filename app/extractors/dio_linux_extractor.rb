
class DioLinuxExtractor < BaseExtractor
  def extract
    title = @doc.css('h1.post-title').first
    content = @doc.css('.post-content').first

    if content
      # Poda de lixo do DioLinux (redes sociais, TOC, banners, aviso de cookies)
      trash_selectors = [
        '.social-share',
        '.post-header-share',
        '.lwptoc',
        '.cc-window',
        '.banner-top',
        '.banner-bottom',
        'div:contains("Seja membro")'
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
