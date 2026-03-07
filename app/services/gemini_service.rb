class GeminiService
  def self.summarize(text)
    return "" if text.blank? || ENV["GEMINI_API_KEY"].blank?

    client = ::Gemini.new(
      credentials: {
        service: "generative-language-api",
        api_key: ENV["GEMINI_API_KEY"]
      },
      options: { model: "gemini-2.5-flash" }
    )

    prompt_template = File.read(Rails.root.join("config", "prompts", "summary_prompt.txt"))
    prompt = prompt_template % { text: text[0..20000] }

    begin
      response = client.generate_content({ contents: { role: "user", parts: { text: prompt } } })
      candidate = response.dig("candidates", 0)
      if candidate && candidate.dig("content", "parts", 0, "text").present?
        candidate.dig("content", "parts", 0, "text")
      else
        reason = candidate&.fetch("finishReason", "UNKNOWN")
        raise "A IA bloqueou ou não gerou o texto (Motivo: #{reason})"
      end
    rescue => e
      safe_message = e.message.gsub(/key=[^&\s]+/, "key=[REDACTED]")
      Rails.logger.error("GeminiService Error: #{safe_message}")
      raise "Erro na IA do Google: #{safe_message}"
    end
  end

  def self.generate_digest(bookmarks, type = "Diário")
    return "Nenhum link encontrado para o período." if bookmarks.empty? || ENV["GEMINI_API_KEY"].blank?

    client = ::Gemini.new(
      credentials: { service: "generative-language-api", api_key: ENV["GEMINI_API_KEY"] },
      options: { model: "gemini-2.5-flash" }
    )

    links_text = bookmarks.map { |b| "Título: #{b.title}\nResumo Original: #{b.summary}\n---" }.join("\n")

    prompt_template = File.read(Rails.root.join("config", "prompts", "digest_prompt.txt"))
    prompt = prompt_template % { type: type, links_text: links_text[0..25000] }

    begin
      response = client.generate_content({ contents: { role: "user", parts: { text: prompt } } })
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
