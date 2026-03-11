# Changelog

Todas as mudanças notáveis deste projeto serão documentadas neste arquivo.
O formato é baseado no [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).

## [2.2.0] - 2026-03-11

### Adicionado
- **Autenticação "Parrudão Black"**: Overhaul visual das telas do Devise (Login, Cadastro e Recuperação de Senha). Os campos agora são imponentes, ocupando 100% da largura do card e com altura ampliada (`1.2rem padding`) para um visual de "cockpit".
- **Checkbox Customizado**: Implementação de checkbox 100% CSS para o "Lembrar-me", com fundo preto profundo e brilho amarelo no hover e seleção, eliminando elementos padrão do sistema operacional.
- **Localização Soberba**: Tradução integral das interfaces de autenticação para Português (Brasil). Labels e links compartilhados agora seguem um padrão sério e profissional ("Entrar", "Criar conta", "Lembrar-me").

### Alterado
- **Aesthetics Sincronizada**: Todos os inputs do sistema (incluindo login e busca) agora compartilham o mesmo DNA visual: fundo `#0c0c0c` (Black), brilho focal amarelo e bordas sutis, garantindo consistência total entre a home e a entrada.
- **Card de Entrada Robusto**: Container de login ajustado para `500px` de largura para melhor leitura e presença visual centralizada.

## [2.1.0] - 2026-03-11

### Adicionado
- **GoiabookLM Imortal**: Script inteligente de automação de deamon (`script/install_service.sh`) para rodar o app no background via Systemd infinitamente.

### Alterado
- **Supervisor do Solid Queue**: Habilitado o plugin do `solid_queue` no Puma (`config/puma.rb`) para que o Rails inicie workers nativamente num mesmo processo.
- **Deploys Zerados (Multi-DB Automático)**: Refatoração da fundação do banco. Migrações satélites transferidas para as respectivas pastas de ambiente (`db/cable_migrate`, etc.) e geração dos esquemas em puro SQL (`*_structure.sql`). Agora um deploy zerado via `bin/setup` carrega todas as tabelas corretamente no SQLite.

## [2.0.0] - 2026-03-11

### Adicionado
- **Paginação Premium**: Integrada a gem `Pagy` (versão 43) com design customizado (Yellow Theme) e botões de fácil clique.
- **Novo Sistema de Boletim (Bulletin)**: Agora o sistema prioriza o resgate do passado, processando os 10 itens não lidos mais antigos da fila em vez de basear-se puramente em datas.
- **Citações de Fontes na IA**: O `GeminiService` agora recebe a URL original para que o Pollux possa citar fontes e satirizar links com falha de processamento ("Baixas de Guerra").
- **Tratamento de Estouro de Página**: Adicionado extra de `overflow` do Pagy para redirecionar automaticamente para a última página válida, evitando erros 500.

### Alterado
- **Renomeação Semântica**: Migração de `DigestsController` para `BulletinsController` e rotas `/digests/*` para `/bulletin`.
- **UI Refinada**: Implementadas abas de filtro ("Todos", "Não Lidas", "Favoritos") com destaque visual e integração com busca e paginação.
- **Estética "Abobrinha"**: Padronização do sistema com o tema Amarelo (`#eab308`) e fontes/botões mais robustos.
- **Lógica de Leitura Automática**: Links resumidos no Boletim são marcados como lidos instantaneamente após o sucesso da geração, mantendo a fila sempre em movimento.

### Corrigido
- Bug de `NameError` e `LoadError` na inicialização do Pagy v43.3.
- Falha onde a coleção de bookmarks sumia da view do Boletim após o comando de atualização no banco.
- Erro no redirecionamento das abas que perdia o contexto da busca.
- Removido código legado do "Boletim Semanal" que não fazia mais sentido no novo fluxo.

## [1.0.0] - 2026-03-06

### Adicionado
- Implementado sistema de detecção de páginas incompletas (paywall/CSR) com aviso visual e deboche automático do Pollux.
- Adicionado status de erro ("IA Capotou") com badge vermelho para falhas na API do Gemini (ex: Erro 429).
- Melhoria no prompt de resumo para lidar com conteúdos truncados e reforçar a personalidade ácida do Pollux.

### Alterado
- Motor de busca alterado de FTS5 para `LIKE` case-insensitive para garantir 100% de confiabilidade nos resultados ("Abobrinator" fix).
- `GeminiService` agora propaga erros de API corretamente para o Job, permitindo atualização de status no banco.
- Refatoração do `ProcessBookmarkJob` para economizar requisições de API em textos muito curtos.
- Atualizada a identidade visual com nova logo transparente (`goiabooklm-removebg.png`) no layout e README.
- Removido título redundante "Minhas Abobrinhas" da página inicial para um visual mais limpo.

### Corrigido
- Bug onde erros da API do Google eram marcados como "Esmiuçado" com sucesso.
- Falha na busca que ignorava termos presentes nos títulos dos favoritos.
- Erro no `DigestsController` que causava crash (tela vermelha) quando a API do Gemini falhava durante a geração de boletins.
- Loop infinito ou travamento do `GeminiService` ao receber respostas bloqueadas por segurança da IA.

### Adicionado
- Projeto inicializado com Ruby `3.4.8` (via asdf) e Rails `8.1.2`.
- Base do projeto gerada via `rails new . -T --database=sqlite3`.
- Gem Devise instalada e configurada com modelo `User`. Banco de dados SQLite inicializado.
- Definição do planejamento de arquitetura (CRUD de favoritos, resumos automáticos por IA com Gemini, busca avançada via SQLite FTS5).
- CRUD Básico de Favoritos gerado com Redcarpet para Markdown nas views (`_bookmark`).
- Adicionada funcionalidade de `toggle_read` para marcar links como lido/não lido.
- Implementação de Busca Textual super rápida via `SQLite FTS5` e integração na View (Index).
- Implementação de `ProcessBookmarkJob` com Sidekiq/SolidQueue que efetua extração limpa (Readability) de novos links e converte em markdown.
- `GeminiService` acoplado ao job gerando análise sarcástica + tags para cada link adicionado.
- Adição dos Boletins Diários e Semanais (Lote) combinando contextos via Inteligência Artificial numa página interativa (`DigestsController`).
- Ajuste do `Procfile.dev` e uso de `foreman` no `bin/dev` para levantar Web e Workers ao mesmo tempo.
- Correção crítica (`CreateSolidQueueTables` manual) da inicialização do banco SQLite oculto para a fila SolidQueue em ambiente dev.
- Resgate da gem `dotenv-rails` que havia sido descartada, destravando a passagem oculta da assinatura Gemini nos processos agendados.
