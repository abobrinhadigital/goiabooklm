require "open-uri"
require "readability"
require "reverse_markdown"

class ProcessBookmarkJob < ApplicationJob
  queue_as :default

  def perform(bookmark_id)
    bookmark = Bookmark.find_by(id: bookmark_id)
    return unless bookmark

    begin
      html = URI.open(
        bookmark.url,
        "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
      ).read
      doc = Readability::Document.new(html, tags: %w[div p h1 h2 h3 h4 h5 h6 ul ol li strong em pre code blockquote img a])

      clean_html = doc.content
      markdown = ReverseMarkdown.convert(clean_html, github_flavored: true)

      if markdown.strip.length < 500
        markdown = "> **[AVISO DO POLLUX]** As defesas anti-robô ou o Client-Side Rendering deste site frustraram o trator. Consegui extrair apenas:\n\n---\n\n" + markdown

        # Tenta pegar título se não tiver
        extracted_title = doc.title || "Sem Título (#{bookmark.url})"
        bookmark.title = extracted_title if bookmark.title.blank?

        bookmark.content = markdown
        bookmark.summary = "A página bateu de cara num muro invisível (paywall, bloqueio de bots ou excesso de JavaScript). Nem gastei meus neurônios de IA tentando ler esse resto de lixo, mestre."
        bookmark.status = 1 # Processado com Sucesso
      else
        # Tenta pegar título se não tiver
        extracted_title = doc.title || "Sem Título (#{bookmark.url})"
        bookmark.title = extracted_title if bookmark.title.blank?

        bookmark.content = markdown
        bookmark.summary = GeminiService.summarize(markdown)
        bookmark.status = 1 # Processado com Sucesso
      end

      bookmark.save(validate: false)
    rescue => e
      error_msg = e.message
      Rails.logger.error("ProcessBookmarkJob Falhou: #{error_msg}")
      bookmark.update_columns(summary: error_msg, status: 2) # status: 2 = erro (IA Capotou)
    end
  end
end
