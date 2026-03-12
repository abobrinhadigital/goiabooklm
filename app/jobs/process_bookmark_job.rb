require "open-uri"
require "readability"
require "reverse_markdown"

class ProcessBookmarkJob < ApplicationJob
  queue_as :default

  def perform(bookmark_id)
    bookmark = Bookmark.find_by(id: bookmark_id)
    return unless bookmark

    begin
      # Headers para tentar passar por um navegador real e evitar erros 429 (Too Many Requests)
      headers = {
        "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
        "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
        "Accept-Language" => "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
        "Referer" => "https://www.google.com/"
      }

      # Adiciona um pequeno atraso aleatório para quebrar a cadência robótica
      sleep(rand(1..3))

      html = URI.open(
        bookmark.url,
        headers.merge(ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
      ).read
      doc = Readability::Document.new(html, tags: %w[div p h1 h2 h3 h4 h5 h6 ul ol li strong em pre code blockquote img a])

      clean_html = doc.content
      markdown = ReverseMarkdown.convert(clean_html, github_flavored: true)

      if markdown.strip.length < 500
        markdown = "> **[AVISO DO POLLUX]** As defesas anti-robô ou o Client-Side Rendering deste site frustraram o trator. Consegui extrair apenas:\n\n---\n\n" + markdown

        # Tenta pegar título se não tiver
        extracted_title = doc.title || "Sem Título (#{bookmark.url})"
        bookmark.title = extracted_title if bookmark.title.blank?

        bookmark.summary = "A página bateu de cara num muro invisível (paywall, bloqueio de bots ou excesso de JavaScript). Nem gastei meus neurônios de IA tentando ler esse resto de lixo, mestre."
        bookmark.status = 1 # Processado com Sucesso
      else
        # Tenta pegar título se não tiver
        extracted_title = doc.title || "Sem Título (#{bookmark.url})"
        bookmark.title = extracted_title if bookmark.title.blank?

        bookmark.summary = GeminiService.summarize(markdown)
        bookmark.status = 1 # Processado com Sucesso
      end

      if bookmark.save(validate: false)
        bookmark.broadcast_replace_to "bookmarks"
      end
    rescue => e
      error_msg = e.message
      Rails.logger.error("ProcessBookmarkJob Falhou: #{error_msg}")
      
      # Garantimos que o status mude para 2 (Erro) e o mestre veja o motivo no card
      final_error = if error_msg.include?("429")
        "O site está de ressaca (Too Many Requests). O Pollux foi barrado. Tente a varinha novamente daqui a pouco."
      elsif error_msg.include?("403")
        "Acesso Proibido. O site detectou o nosso trator e barrou a entrada."
      else
        error_msg
      end

      bookmark.update(
        summary: "> **[IA CAPOTOU]** #{final_error}", 
        status: 2
      )
      bookmark.broadcast_replace_to "bookmarks"
    end
  end
end
