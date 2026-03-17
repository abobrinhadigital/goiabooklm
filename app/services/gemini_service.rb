require 'net/http'
require 'uri'
require 'json'

class GeminiService
  def self.summarize(text)
    return "" if text.blank? || ENV["GEMINI_API_KEY"].blank?

    prompt = File.read(Rails.root.join("config", "prompts", "summary_prompt.md"))
    call_gemini(prompt, text[0..20000])
  end

  def self.generate_digest(bookmarks, type = "Resumido", failed_bookmarks = [])
    return "Nenhum link encontrado para o período." if bookmarks.empty? && failed_bookmarks.empty?
    return "Erro de API Key." if ENV["GEMINI_API_KEY"].blank?

    links_text = bookmarks.map { |b| "Título: #{b.title}\nURL: #{b.url}\nResumo Original: #{b.summary}\n---" }.join("\n")
    
    if failed_bookmarks.any?
      links_text += "\n\nLINKS QUE FALHARAM (SATIRIZE ESTES NO FINAL):\n"
      links_text += failed_bookmarks.map { |b| "URL: #{b.url} (ERRO DE PROCESSAMENTO)" }.join("\n")
    end

    prompt = File.read(Rails.root.join("config", "prompts", "digest_prompt.md"))
    call_gemini(prompt, links_text[0..25000])
  end

  private

  def self.call_gemini(system_prompt, user_text)
    api_key = ENV["GEMINI_API_KEY"]
    model = ENV["GEMINI_MODEL"] || "gemini-2.0-flash"
    uri = URI("https://generativelanguage.googleapis.com/v1beta/models/#{model}:generateContent?key=#{api_key}")

    payload = {
      system_instruction: {
        parts: { text: system_prompt }
      },
      contents: [
        {
          role: "user",
          parts: [{ text: user_text }]
        }
      ]
    }.to_json

    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.read_timeout = 30

      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request.body = payload

      response = http.request(request)

      if response.code == "200"
        result = JSON.parse(response.body)
        text = result.dig("candidates", 0, "content", "parts", 0, "text")
        if text.present?
          text
        else
          raise "A IA não gerou texto (Motivo: #{result.dig("candidates", 0, "finishReason") || 'UNKNOWN'})"
        end
      else
        raise "Erro da API Gemini (#{response.code}): #{response.body}"
      end
    rescue => e
      safe_message = e.message.gsub(/key=[^&\s]+/, "key=[REDACTED]")
      Rails.logger.error("GeminiService Error: #{safe_message}")
      
      if safe_message.include?("429")
        raise "Cota de IA excedida (Aguarde alguns minutos)"
      elsif safe_message.include?("Timeout") || safe_message.include?("Failed to open TCP")
        raise "Erro de rede com o Google (Timeout ou Conexão)"
      else
        raise "Erro na IA do Google: #{safe_message}"
      end
    end
  end
end
