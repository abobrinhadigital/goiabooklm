<p align="center">
  <img src="app/assets/images/goiabooklm-removebg.png" alt="GoiabookLM Logo" width="200">
</p>

# GoiabookLM

GoiabookLM e um sistema de curadoria e arquivamento de links (favoritos) que utiliza a inteligencia artificial do Google Gemini para processar, limpar e resumir conteudos da web. O projeto e operado sob a persona de Pollux, um assistente digital acido e sarcastico que garante que seu mestre (Celo) nao precise ler textos inuteis ou incompletos.

## O Que e o Projeto

Diferente de um simples gerenciador de bookmarks, o GoiabookLM atua como um trator de conteudo. Ao adicionar um link, o sistema:
1. Extrai o texto limpo da pagina eliminando publicidade e banners.
2. Converte o conteudo para Markdown para leitura offline.
3. Utiliza o Gemini 2.5 Flash para gerar um resumo ironico e acido.
4. Detecta automaticamente se a pagina foi bloqueada por paywalls ou scripts.
5. Organiza tudo em um feed cronologico com busca textual.

## Funcionalidades Principais

- Processamento em Segundo Plano: Utiliza workers para garantir que a interface nao trave enquanto a IA processa os links.
- Resumos de IA: Resumos curtos e honestos (da perspectiva do Pollux) para cada link salvo.
- Boletins (Digests): Geracao de resumos diarios ou semanais que consolidam todos os links salvos em um unico boletim estruturado.
- Busca Robusta: Sistema de busca que varre titulos, conteudos, resumos e URLs.
- Interface Minimalista: Design focado na leitura e organizacao rapida.

## Pilha Tecnica

- Linguagem: Ruby 3.4.8
- Framework: Rails 8.1.2
- Banco de Dados: SQLite3
- Inteligencia Artificial: Google Gemini API (Modelo gemini-2.5-flash)
- Processamento: Solid Queue
- Front-end: Vanilla CSS e Hotwire (Turbo/Stimulus)

## Instalacao e Configuracao

Requisitos: Ruby 3.4.8 e SQLite3 instalado.

1. Clone o repositorio.
2. Execute 'bundle install'.
3. Configure o arquivo '.env' na raiz com a sua 'GEMINI_API_KEY'.
4. Execute as migracoes: 'bin/rails db:prepare'.
5. Inicie o ambiente de desenvolvimento: 'bin/dev'.

## Persona Pollux

O projeto e mantido sob a supervisao de Pollux, o Biografo do Azar. Se o sistema falhar ao carregar uma pagina ou se a IA capotar, o Pollux fara questao de documentar a falha com o sarcasmo devido, mantendo a "Curadoria do Erro" como pilar central da experiencia.
