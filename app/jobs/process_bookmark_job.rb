require "open-uri"
require "readability"
require "reverse_markdown"

class ProcessBookmarkJob < ApplicationJob
  queue_as :default

  def perform(bookmark_id)
    bookmark = Bookmark.find_by(id: bookmark_id)
    return unless bookmark

    headers = {
      "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
      "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
      "Accept-Language" => "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
      "Referer" => "https://www.google.com/"
    }

    used_marreta = false
    begin
      # Tentativa 1: Acesso Direto
      html = fetch_content(bookmark.url, headers)
      markdown = extract_markdown(html)

      # Se o conteúdo for muito curto, pode ser WAF/Bloqueio. Tentamos o Marreta.
      if markdown.strip.length < 500
        Rails.logger.info("Conteúdo muito curto para #{bookmark.url}. Acionando Marreta...")
        used_marreta = true
        html = fetch_content(marreta_url(bookmark.url), headers)
        markdown = extract_markdown(html)
      end

      process_content(bookmark, markdown, used_marreta)
    rescue => e
      # Tentativa 2: Fallback para Marreta em caso de erro (403, 429, etc)
      unless used_marreta
        begin
          Rails.logger.warn("Falha no acesso direto para #{bookmark.url}: #{e.message}. Tentando Marreta...")
          used_marreta = true
          html = fetch_content(marreta_url(bookmark.url), headers)
          markdown = extract_markdown(html)
          process_content(bookmark, markdown, used_marreta)
          return # Sucesso via Marreta
        rescue => e_marreta
          e = e_marreta # Se o Marreta também falhar, reportamos o erro dele
        end
      end

      handle_error(bookmark, e)
    end
  end

  private

  def fetch_content(url, headers)
    sleep(rand(1..2)) # Atraso estratégico
    URI.open(url, headers.merge(ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)).read
  end

  def extract_markdown(html)
    doc = Readability::Document.new(html, tags: %w[div p h1 h2 h3 h4 h5 h6 ul ol li strong em pre code blockquote img a])
    clean_html = doc.content
    ReverseMarkdown.convert(clean_html, github_flavored: true)
  end

  def marreta_url(url)
    url_encoded = URI.encode_www_form_component(url)
    "https://marreta.pcdomanual.com/#{url_encoded}"
  end

  def process_content(bookmark, markdown, used_marreta)
    if markdown.strip.length < 500
      tag = used_marreta ? "[MARRETA FALHOU]" : "[POLLUX BARRADO]"
      bookmark.summary = "> **#{tag}** As defesas anti-robô frustraram o trator completamente. Nem o Marreta resolveu, mestre."
      bookmark.status = 1
    else
      prefix = used_marreta ? "> **[CONTEÚDO VIA MARRETA]**\n\n" : ""
      bookmark.summary = prefix + GeminiService.summarize(markdown)
      bookmark.status = 1
    end

    save_and_notify(bookmark)
  end

  def handle_error(bookmark, e)
    error_msg = e.message
    Rails.logger.error("ProcessBookmarkJob Falhou: #{error_msg}")

    final_error = if error_msg.include?("429")
      "O site está de ressaca (429). Pollux e Marreta foram barrados."
    elsif error_msg.include?("403")
      "Acesso Proibido (403). O site detectou o nosso trator e até o Marreta."
    else
      error_msg
    end

    bookmark.update(summary: "> **[IA CAPOTOU]** #{final_error}", status: 2)
    save_and_notify(bookmark)
  end

  def save_and_notify(bookmark)
    if bookmark.save(validate: false)
      bookmark.broadcast_replace_to "bookmarks"
      PessegramService.notify(bookmark)
    end
  end
end
