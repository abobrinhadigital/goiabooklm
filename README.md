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
- Resumos de IA: Resumos curtos e honestos (da perspectiva do Pollux) para cada link salvo.
- Boletins (Digests): Geração de resumos diários ou semanais que consolidam todos os links salvos em um único boletim estruturado.
- Busca Robusta: Sistema de busca que varre títulos, conteúdos, resumos e URLs.
- Interface Minimalista: Design focado na leitura e organização rápida.

## Pilha Técnica

- Linguagem: Ruby 3.4.8
- Framework: Rails 8.1.2
- Banco de Dados: SQLite3
- Inteligência Artificial: Google Gemini API (Modelo gemini-2.5-flash)
- Processamento: Solid Queue
- Front-end: Vanilla CSS e Hotwire (Turbo/Stimulus)

## Instalação e Configuração

Requisitos: Ruby 3.4.8 e SQLite3 instalado.

1. Clone o repositório.
2. Execute 'bundle install'.
3. Configure o arquivo '.env' na raiz com a sua 'GEMINI_API_KEY'.
4. Execute as migrações: 'bin/rails db:prepare'.
5. Inicie o ambiente de desenvolvimento: 'bin/dev'.

## Persona Pollux

O projeto é mantido sob a supervisão de Pollux, o Biógrafo do Azar. Se o sistema falhar ao carregar uma página ou se a IA capotar, o Pollux fará questão de documentar a falha com o sarcasmo devido, mantendo a "Curadoria do Erro" como pilar central da experiência.
