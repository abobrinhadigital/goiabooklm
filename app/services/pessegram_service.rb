require "net/http"
require "uri"

class PessegramService
  def self.notify(bookmark)
    return unless bookmark.source == "pessegram"

    # Novo endpoint: /bot/goiabooklm
    base_url = ENV["PESSEGRAM_API_URL"] # ex: http://localhost:7355
    token = ENV["PESSEGRAM_API_TOKEN"]
    chat_id = ENV["PESSEGRAM_CHAT_ID"] # ID do chat do mestre

    return if base_url.blank?

    message = format_message(bookmark)

    begin
      # Montar URL do endpoint /bot/goiabooklm
      uri = URI.parse(base_url)
      uri.path = "/bot/goiabooklm"

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path, {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{token}"
      })
      request.body = {
        mensagem: message,
        chat_id: chat_id
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
      "**Resumo:**\n#{bookmark.summary}"
    else # Erro (status 2 ou qualquer outro susto)
      "❌ **[GoiabookLM Engasgou!]**\n\n" \
      "**Link:** #{bookmark.url}\n" \
      "**O que houve:** #{bookmark.summary}"
    end
  end
end
