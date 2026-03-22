<p align="center">
  <img src="app/assets/images/goiabooklm-removebg.png" alt="GoiabookLM Logo" width="200">
</p>

# GoiabookLM

GoiabookLM é um sistema de curadoria e arquivamento de links (favoritos) que utiliza a inteligência artificial do Google Gemini para processar, limpar e resumir conteúdos da web. O projeto é operado sob a persona de Pollux, um assistente digital ácido e sarcástico que garante que seu mestre (Celo) não precise ler textos inúteis ou incompletos.

## O Que é o Projeto

O GoiabookLM nasceu da necessidade visceral do mestre em gerenciar o caos informativo, começando como um agregador "read it later" humilde. Com o tempo, ele evoluiu para uma central de curadoria e favoritos inteligente, focada em economizar o tempo de quem sofre com a Lei de Murphy.

Ao adicionar um link, o sistema:
1. **Sanitiza a URL**: Remove rastreadores e lixo de marketing.
2. **Gera Resumos Ácidos**: Usa o Gemini 2.5 Flash para criar uma síntese irônica do conteúdo, para que você não precise abrir o link se ele for inútil.
3. **Organiza o Caos**: Mantém um feed cronológico com busca baseada nos resumos gerados.
4. **Notifica pelo Pessegram**: Envia a "fofoca" (o resumo) diretamente para o Telegram se o link veio de lá.

## Funcionalidades

- **Reprocessamento Sob Demanda (Varinha Mágica)**: Controle manual para solicitar ou refazer resumos de IA diretamente no feed.
- Processamento em Segundo Plano: Utiliza workers para garantir que a interface não trave enquanto a IA processa os links.
- **Higienização de Links (Incinerador)**: Limpeza automática de rastreadores (UTM, ref, tags de marketing) usando o motor ClearURLs e regras customizadas.
- **Extração Cirúrgica (Crawler Squadron)**: Sistema modular de extratores que identifica títulos e conteúdos em sites específicos, removendo anúncios e lixo visual antes de processar com IA.
- **Fofoca Automática (Integração Pessegram)**: Envio instantâneo de resumos ácidos de volta para o Telegram para links recebidos via API.
- **Central de Configurações**: Painel dedicado para gerenciar regras de sanitização, comportamento do sistema e a **voz do Pollux** (editores de prompt integrados).
- Boletim Resumido (Bulletin): Sistema de resgate que consolida os 10 itens não lidos mais antigos, marcando-os como lidos automaticamente e satirizando falhas.
- Paginação Premium: Navegação fluida via gem Pagy com interface amigável.
- Busca Robusta: Sistema de busca que varre títulos, resumos e URLs.
- Interface Minimalista & Editorial: Design focado na leitura e organização por abas.

## Pilha Técnica

- Linguagem: Ruby 3.4.8
- Framework: Rails 8.1.2
- Banco de Dados: SQLite3
- Inteligência Artificial: Google Gemini API (Modelo gemini-2.5-flash)
- Processamento: Solid Queue
- Front-end: Vanilla CSS e Hotwire (Turbo/Stimulus)

## Instalação e Configuração

Requisitos: Ruby 3.4.8 e SQLite3 instalado.

**1. Preparando o Terreno**
Clone o repositório, entre na pasta e configure as chaves vitais:
```bash
git clone https://github.com/mestre/goiabooklm.git
cd goiabooklm

# Edite ou crie o .env e adicione pelo menos:
# GEMINI_API_KEY=sua_chave
# SECRET_KEY_BASE=gere_uma_com_o_comando_'rails_secret'
```

> [!IMPORTANT]
> Em produção, o Rails exige a `SECRET_KEY_BASE`. Gere uma executando `bundle exec rails secret` e cole o resultado no seu `.env`. Sem isso, o setup irá falhar.

**2. Instalação Inicial**
O script mágico do Rails instalará gems e preparará os bancos. Em servidores de produção, use o comando abaixo para garantir a migração correta:
```bash
RAILS_ENV=production bin/setup --skip-server
```

> [!TIP]
> O `bin/setup` é inteligente: ele detecta o ambiente, migra todos os bancos (Multi-DB) e pré-compila os assets automaticamente.

**3. Atualizando o Sistema**
Sempre que o mestre decidir trazer novidades do repositório, o ritual é simples:
```bash
RAILS_ENV=production ./update.sh
```

> [!TIP]
> O `update.sh` é o maestro dessa bagunça: ele limpa processos zumbis, migra o banco e reinicia todos os serviços (App e Worker) em harmonia.

**4. Invocação Definitiva (A Imortalidade)**
Para rodar em background permanentemente, instale o projeto como um serviço:
```bash
chmod +x script/install_service.sh
./script/install_service.sh
```
*(Siga as instruções do Systemd fornecidas na tela pelo script.)*

## Integração com Pessegram v4.0.0

O GoiabookLM agora faz parte da arquitetura multi-bot do Pessegram v4.0.0:

- **Bot GoiabookLM**: Bot especializado que recebe URLs via webhook do Telegram
- **API Direta**: O bot envia URLs diretamente para a API do GoiabookLM (porta 3000)
- **Notificação Automática**: Resumos são enviados de volta ao Telegram via PessegramService
- **Cloudflare Tunnel**: Integração com túneis Cloudflare para exposição segura

O bot opera de forma independente, mas integrada ao ecossistema Pessegram.

## Persona Pollux

O projeto é mantido sob a supervisão de Pollux, o Biógrafo do Azar. Se o sistema falhar ao carregar uma página ou se a IA capotar, o Pollux fará questão de documentar a falha com o sarcasmo devido, mantendo a "Curadoria do Erro" como pilar central da experiência.
