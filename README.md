<p align="center">
  <img src="app/assets/images/goiabooklm-removebg.png" alt="GoiabookLM Logo" width="200">
</p>

# GoiabookLM

GoiabookLM é um sistema de curadoria e arquivamento de links (favoritos) que utiliza a inteligência artificial do Google Gemini para processar, limpar e resumir conteúdos da web. O projeto é operado sob a persona de Pollux, um assistente digital ácido e sarcástico que garante que seu mestre (Celo) não precise ler textos inúteis ou incompletos.

## O Que é o Projeto

Diferente de um simples gerenciador de bookmarks, o GoiabookLM atua como um trator de conteúdo. Ao adicionar um link, o sistema:
1. Extrai o texto limpo da página eliminando publicidade e banners.
2. Converte o conteúdo para Markdown para leitura offline.
3. Utiliza o Gemini 2.5 Flash para gerar um resumo irônico e ácido.
4. Detecta automaticamente se a página foi bloqueada por paywalls ou scripts.
5. Organiza tudo em um feed cronológico com busca textual.

## Funcionalidades Principais

- Processamento em Segundo Plano: Utiliza workers para garantir que a interface não trave enquanto a IA processa os links.
- **Higienização de Links (Incinerador)**: Limpeza automática de rastreadores (UTM, ref, tags de marketing) usando o motor ClearURLs e regras customizadas.
- Resumos de IA: Resumos curtos e honestos (da perspectiva do Pollux) para cada link salvo.
- **Central de Configurações**: Painel dedicado para gerenciar regras de sanitização e comportamento do sistema.
- Boletim Resumido (Bulletin): Sistema de resgate que consolida os 10 itens não lidos mais antigos, marcando-os como lidos automaticamente e satirizando falhas.
- Paginação Premium: Navegação fluida via gem Pagy com interface amigável.
- Busca Robusta: Sistema de busca que varre títulos, conteúdos, resumos e URLs.
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

**2. Instalando Dependências e Bancos**
O script mágico do Rails instalará gems e preparará os bancos. Use a flag `--skip-server` para evitar que ele trave o seu terminal no final:
```bash
RAILS_ENV=production bin/setup --skip-server
```

**3. Invocação Definitiva (A Imortalidade)**
Para não ter que deixar o terminal aberto vigilante, instale o projeto como um serviço do Linux:
```bash
chmod +x script/install_service.sh
./script/install_service.sh
```
*(Siga as 3 instruções `sudo systemctl` fornecidas na tela pelo script e pronto!)**(Siga as 3 instruções `sudo systemctl` fornecidas na tela pelo script e pronto!)*

## Persona Pollux

O projeto é mantido sob a supervisão de Pollux, o Biógrafo do Azar. Se o sistema falhar ao carregar uma página ou se a IA capotar, o Pollux fará questão de documentar a falha com o sarcasmo devido, mantendo a "Curadoria do Erro" como pilar central da experiência.
