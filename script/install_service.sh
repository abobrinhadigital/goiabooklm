#!/usr/bin/env bash

# GoiabookLM Service Installer
# Este script cria um serviço no Systemd para rodar o GoiabookLM 
# automaticamente em background com workers integrados.

set -e

APP_DIR=$(pwd)
USER=$(whoami)
RUBY_BIN=$(which ruby)
BUNDLE_BIN=$(which bundle)

SERVICE_FILE="/tmp/goiabooklm.service"

echo "==> Gerando arquivo de serviço do Systemd para o usuário $USER"

cat <<EOF > $SERVICE_FILE
[Unit]
Description=GoiabookLM Application Server with Solid Queue Workers
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$APP_DIR

# Variáveis de ambiente
Environment=RAILS_ENV=production
Environment=SOLID_QUEUE_IN_PUMA=true
Environment=PORT=3000

# Execução (usando o binstub do próprio projeto)
ExecStart=$BUNDLE_BIN exec rails server -p 3000 -e production

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "==> Arquivo gerado em $SERVICE_FILE"
echo "==> Para instalar no sistema, instale com root:"
echo "    sudo mv $SERVICE_FILE /etc/systemd/system/goiabooklm.service"
echo "    sudo systemctl daemon-reload"
echo "    sudo systemctl enable --now goiabooklm"
echo ""
echo "O GoiabookLM rodará eternamente no background!"
