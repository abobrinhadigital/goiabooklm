class GeminiService
  def self.summarize(text)
    return "" if text.blank? || ENV["GEMINI_API_KEY"].blank?

    client = ::Gemini.new(
      credentials: {
        service: "generative-language-api",
        api_key: ENV["GEMINI_API_KEY"]
      },
      options: { model: ENV["GEMINI_MODEL"] || "gemini-2.0-flash", timeout: 30 }
    )

    system_instruction = File.read(Rails.root.join("config", "prompts", "summary_prompt.md"))

    begin
      response = client.generate_content({
        system_instruction: { 
          parts: { text: system_instruction } 
        },
        contents: [
          {
            role: "user",
            parts: [{ text: text[0..20000] }]
          }
        ]
      })
      candidate = response.dig("candidates", 0)
      if candidate && candidate.dig("content", "parts", 0, "text").present?
        candidate.dig("content", "parts", 0, "text")
      else
        reason = candidate&.fetch("finishReason", "UNKNOWN")
        raise "A IA bloqueou ou não gerou o texto (Motivo: #{reason})"
      end
    rescue Faraday::Error => e
      Rails.logger.error("GeminiService Network Error: #{e.message}")
      raise "Erro de rede com o Google (Timeout ou Conexão)"
    rescue => e
      safe_message = e.message.gsub(/key=[^&\s]+/, "key=[REDACTED]")
      
      if safe_message.include?("RESOURCE_EXHAUSTED")
        raise "Cota de IA excedida (Aguarde alguns minutos)"
      end

      Rails.logger.error("GeminiService Error: #{safe_message}")
      raise "Erro na IA do Google: #{safe_message}"
    end
  end

  def self.generate_digest(bookmarks, type = "Resumido", failed_bookmarks = [])
    return "Nenhum link encontrado para o período." if bookmarks.empty? && failed_bookmarks.empty?
    return "Erro de API Key." if ENV["GEMINI_API_KEY"].blank?

    client = ::Gemini.new(
      credentials: { service: "generative-language-api", api_key: ENV["GEMINI_API_KEY"] },
      options: { model: ENV["GEMINI_MODEL"] || "gemini-2.0-flash", timeout: 30 }
    )

    links_text = bookmarks.map { |b| "Título: #{b.title}\nURL: #{b.url}\nResumo Original: #{b.summary}\n---" }.join("\n")
    
    if failed_bookmarks.any?
      links_text += "\n\nLINKS QUE FALHARAM (SATIRIZE ESTES NO FINAL):\n"
      links_text += failed_bookmarks.map { |b| "URL: #{b.url} (ERRO DE PROCESSAMENTO)" }.join("\n")
    end

    system_instruction = File.read(Rails.root.join("config", "prompts", "digest_prompt.md"))

    begin
      response = client.generate_content({
        system_instruction: { parts: { text: system_instruction } },
        contents: [
          {
            role: "user",
            parts: [{ text: links_text[0..25000] }]
          }
        ]
      })
      candidate = response.dig("candidates", 0)
      if candidate && candidate.dig("content", "parts", 0, "text").present?
        candidate.dig("content", "parts", 0, "text")
      else
        reason = candidate&.fetch("finishReason", "UNKNOWN")
        raise "O Boletim foi bloqueado pela IA (Motivo: #{reason})"
      end
    rescue => e
      safe_message = e.message.gsub(/key=[^&\s]+/, "key=[REDACTED]")
      Rails.logger.error("GeminiService Digest Error: #{safe_message}")
      raise "Erro no Boletim: #{safe_message}"
    end
  end
end
