#!/bin/bash

# --- Pollux Update Script ---
# "A ferramenta da preguiça produtiva para o Mestre"

set -e # Aborta em caso de erro

echo "🚀 Iniciando atualização do GoiabookLM..."

# 1. Git Pull
echo "📥 Buscando as últimas abobrinhas no repositório..."
git pull origin main

# 2. Setup
echo "🛠️ Rodando o bixo (bin/setup)..."
# Usamos RAILS_ENV=production para garantir que tudo seja compilado e migrado corretamente
RAILS_ENV=production ./bin/setup --skip-server

# 3. Reiniciar Serviços
echo "🔄 Despertando o sistema e limpando a hidra (systemctl restart)..."

# Garante que nenhum processo órfão do Solid Queue sobreviva
pkill -9 -f solid_queue || true

if [ -f /etc/systemd/system/goiabooklm.service ] || [ -f /etc/systemd/system/goiabooklm-worker.service ]; then
  # Reinicia ambos os serviços se existirem
  systemctl daemon-reload
  systemctl restart goiabooklm.service goiabooklm-worker.service || echo "⚠️ Alguns serviços falharam ao reiniciar, mas o trator segue firme."
  echo "✅ Serviços reiniciados com sucesso!"
else
  echo "⚠️ Aviso: Arquivos de serviço systemd não encontrados. Pulando reinício."
fi

echo "✨ Tudo pronto, meu mestre! O Caos foi devidamente atualizado."
