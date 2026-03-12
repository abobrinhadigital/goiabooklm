# Configurações Iniciais do GoiabookLM
puts "Dando vida ao Cockpit..."

# Template inicial de regras customizadas (JSON)
custom_rules_template = {
  "providers": {
    "youtube": {
      "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?(youtube\\.com|youtu\\.be)",
      "rules": ["feature", "si", "pp"]
    }
  },
  "globalRules": {
    "rules": ["utm_[a-z_]*", "fbclid", "gclid"]
  }
}

Setting.set("custom_rules", custom_rules_template)

# Dispara a primeira sincronização do ClearURLs (Bloqueante no setup para garantir que o mestre tenha regras)
puts "Sincronizando incineradores do ClearURLs (isso pode levar alguns segundos)..."
begin
  SyncClearUrlsJob.perform_now
  puts "Sincronização concluída: #{Setting.get("last_automated_sync_at")}"
rescue => e
  puts "Aviso: Falha na sincronização inicial do ClearURLs. O mestre terá apenas as regras customizadas por enquanto. Erro: #{e.message}"
end

puts "Cockpit pronto para decolagem!"
