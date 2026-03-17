
class TudocelularExtractor < BaseExtractor
  def extract
    title = @doc.css("#hero h2").first
    content = @doc.css('.content').first

    if content
      # Poda de lixo do TudoCelular
      trash_selectors = [
        '.big_notices',
        '.item_compra',
        '.social_buttons',
        '#adv_fondo_post'
      ].join(', ')
      content.css(trash_selectors).remove
    end

    if title || content
      # Combinamos o título e o conteúdo em um fragmento HTML temporário
      combined_html = "#{title}#{content}"
      clean_markdown(combined_html)
    else
      super
    end
  end
end
