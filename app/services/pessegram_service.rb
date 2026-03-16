require "net/http"
require "uri"

class PessegramService
  def self.notify(bookmark)
    return unless bookmark.source == "pessegram"

    url = ENV["PESSEGRAM_API_URL"]
    token = ENV["PESSEGRAM_API_TOKEN"]

    return if url.blank?

    message = format_message(bookmark)

    begin
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
      request.body = {
        token: token,
        mensagem: message
      }.to_json

      response = http.request(request)

      unless response.is_a?(Net::HTTPSuccess)
        Rails.logger.error("PessegramService Falhou: #{response.code} - #{response.body}")
      end
    rescue => e
      Rails.logger.error("PessegramService Erro de Conexão: #{e.message}")
    end
  end

  private

  def self.format_message(bookmark)
    if bookmark.status == 1 # Sucesso
      "✅ **[GoiabookLM Processou!]**\n\n" \
      "**Título:** #{bookmark.title}\n" \
      "**Link:** #{bookmark.url}\n\n" \
      "**Resumo do Pollux:**\n#{bookmark.summary}"
    else # Erro (status 2 ou qualquer outro susto)
      "❌ **[GoiabookLM Engasgou!]**\n\n" \
      "**Link:** #{bookmark.url}\n" \
      "**O que houve:** #{bookmark.summary}"
    end
  end
end
