require 'cgi'

class UrlSanitizer
  def self.call(url)
    return url if url.blank?

    begin
      uri = URI.parse(url)
      return url unless uri.query

      params = CGI.parse(uri.query)
      rules = fetch_merged_rules(uri.host)

      # Limpa os parâmetros
      clean_params = params.reject do |key, _|
        should_remove_param?(key, rules)
      end

      if clean_params.empty?
        uri.query = nil
      else
        # Transforma os arrays de volta em valores simples antes de encodar
        # (CGI.parse retorna { 'key' => ['val1'] })
        flat_params = clean_params.transform_values(&:first)
        uri.query = URI.encode_www_form(flat_params)
      end

      uri.to_s
    rescue URI::InvalidURIError
      url
    end
  end

  private

  def self.fetch_merged_rules(host)
    # Pega as regras automatizadas do banco (JSON)
    automated = Setting.get("automated_rules") || { "globalRules" => { "rules" => [] }, "providers" => {} }
    
    # Pega as regras customizadas do banco (JSON)
    custom = Setting.get("custom_rules") || { "globalRules" => { "rules" => [] }, "providers" => {} }

    # Mescla as regras (Deep Merge simplificado)
    global_rules = (automated.dig("globalRules", "rules") || []) + (custom.dig("globalRules", "rules") || [])
    
    # Busca regras específicas do provider (host)
    provider_rules = []
    
    # Helper para criar regex de forma segura
    safe_host_match = ->(pattern, target_host) {
      begin
        # Escapa hífens em classes de caracteres para evitar avisos do Ruby 3
        sanitized_pattern = pattern.gsub(/(?<!\\)-/, "\\-")
        target_host =~ Regexp.new(sanitized_pattern, Regexp::IGNORECASE)
      rescue RegexpError
        false
      end
    }

    # Procura no automated
    automated["providers"]&.each do |name, config|
      if safe_host_match.call(config["urlPattern"], host)
        provider_rules += config["rules"] if config["rules"]
      end
    end

    # Procura no custom (sobrescreve/adiciona)
    custom["providers"]&.each do |name, config|
      if safe_host_match.call(config["urlPattern"], host)
        provider_rules += config["rules"] if config["rules"]
      end
    end

    { global: global_rules.uniq, provider: provider_rules.uniq }
  end

  def self.should_remove_param?(key, rules)
    # Whitelist sagrada: NUNCA remover
    return false if ["v", "t", "id", "p", "page"].include?(key.downcase)

    # Verifica se bate com alguma regra (Global ou Provider)
    all_rules = rules[:global] + rules[:provider]
    
    all_rules.any? do |rule|
      key =~ Regexp.new("^#{rule}$", Regexp::IGNORECASE) || key =~ Regexp.new(rule, Regexp::IGNORECASE)
    end
  end
end
