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

# 3. Reiniciar Serviço
echo "🔄 Despertando o sistema (systemctl restart)..."
if [ -f /etc/systemd/system/goiabooklm.service ]; then
  systemctl restart goiabooklm
  echo "✅ Sistema reiniciado com sucesso!"
else
  echo "⚠️ Aviso: Arquivo de serviço systemd não encontrado. Pulando reinício."
fi

echo "✨ Tudo pronto, meu mestre! O Caos foi devidamente atualizado."
