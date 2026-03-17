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

    used_scrapedo = false
    begin
      # Tentativa 1: Acesso Direto
      html = fetch_content(bookmark.url, headers)
      markdown = extract_markdown(bookmark.url, html)

      # Se o conteúdo for muito curto, pode ser WAF/Bloqueio. Tentamos o Scrape.do.
      if markdown.strip.length < 500
        Rails.logger.info("Conteúdo muito curto para #{bookmark.url}. Acionando Scrape.do...")
        used_scrapedo = true
        html = fetch_content(scrapedo_url(bookmark.url), headers)
        markdown = extract_markdown(bookmark.url, html)
      end

      process_content(bookmark, markdown, used_scrapedo)
    rescue => e
      # Tentativa 2: Fallback para Scrape.do em caso de erro (403, 429, etc)
      unless used_scrapedo
        begin
          Rails.logger.warn("Falha no acesso direto para #{bookmark.url}: #{e.message}. Tentando Scrape.do...")
          used_scrapedo = true
          html = fetch_content(scrapedo_url(bookmark.url), headers)
          markdown = extract_markdown(bookmark.url, html)
          process_content(bookmark, markdown, used_scrapedo)
          return # Sucesso via Scrape.do
        rescue => e_scrapedo
          e = e_scrapedo # Se o Scrape.do também falhar, reportamos o erro dele
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

  def extract_markdown(url, html)
    ExtractorFactory.extract(url, html)
  end

  def scrapedo_url(url)
    token = ENV['SCRAPE_DO_API_TOKEN']
    url_encoded = CGI.escape(url)
    "https://api.scrape.do/?url=#{url_encoded}&token=#{token}"
  end

  def process_content(bookmark, markdown, used_scrapedo)
    if markdown.strip.length < 500
      tag = used_scrapedo ? "[SCRAPE.DO FALHOU]" : "[POLLUX BARRADO]"
      bookmark.summary = "> **#{tag}** As defesas anti-robô frustraram o trator completamente. Nem o Scrape.do resolveu, mestre."
      bookmark.status = 1
    else
      prefix = used_scrapedo ? "> **[CONTEÚDO VIA SCRAPE.DO]**\n\n" : ""
      bookmark.summary = prefix + GeminiService.summarize(markdown)
      bookmark.status = 1
    end

    save_and_notify(bookmark)
  end

  def handle_error(bookmark, e)
    error_msg = e.message
    Rails.logger.error("ProcessBookmarkJob Falhou: #{error_msg}")

    final_error = if error_msg.include?("429")
      "O site está de ressaca (429). Pollux e Scrape.do foram barrados."
    elsif error_msg.include?("403")
      "Acesso Proibido (403). O site detectou o nosso trator e até o Scrape.do."
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
