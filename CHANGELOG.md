## [4.1.1] - 2026-03-17

### Corrigido
- **Visibilidade de Navegação**: Adicionado o link de acesso aos Prompts no menu de configurações lateral, simplificando o fluxo de edição para o mestre.

## [4.1.0] - 2026-03-17

### Adicionado
- **Editores de Personalidade (Prompt Editor)**: Nova interface para calibração da voz do Pollux. Agora o mestre pode editar as instruções de "Resumo" e "Boletim" diretamente no painel de Configurações, sem tocar em arquivos via terminal.
- **Persistência em Disco**: Sistema de I/O direto que salva as alterações nos arquivos markdown de configuração, garantindo que o `GeminiService` use as novas diretrizes instantaneamente sem precisar reiniciar o serviço.

## [4.0.0] - 2026-03-16

### Adicionado
- **Sistema de Extratores Modulares (The Crawler Squadron)**: Introdução de uma arquitetura extensível para extração de conteúdo site-a-site.
- **Surgical Site Crawlers**: Implementação de 9 extratores especializados (XDA, How-To-Geek, It's FOSS, Tecnoblog, TudoCelular, GSMArena, 9to5Linux, DioLinux, OMG! Ubuntu!) que utilizam seletores precisos para capturar títulos, subtítulos e conteúdo real.
- **Limpeza Profunda (Digital Detox)**: Poda agressiva de anúncios, widgets sociais, barras laterais e elementos de marketing, garantindo que a IA receba apenas o "filé mignon" do texto.
- **Fallback Inteligente**: Integração com `Readability` como plano de contingência para sites sem extratores dedicados.

## [3.2.0] - 2026-03-15

### Adicionado
- **Integração Retrô-Pessegram**: Agora a Goiaba fofoca de volta! Todo link enviado via Telegram recebe um resumo automático de volta no Pessegram via `PessegramService`.
- **Memória de Origem (`source`)**: Novo campo na tabela de bookmarks para rastrear de onde veio o link (`pessegram` ou `web`). Evita spam de notificações para links salvos via interface web.
- **PessegramService (A "Lib" da Fofoca)**: Serviço dedicado para comunicação com a API do Pessegram, com suporte a Bearer Token e formatação ácida automática.

### Alterado
- **Orquestração de Deploys (`update.sh`)**: Script de atualização fortalecido para lidar com a "Hidra de Processos". Agora ele limpa processos órfãos do Solid Queue (`pkill -9`) e reinicia múltiplos serviços (`application` e `worker`) em harmonia.

### Corrigido
- **Morte aos Zumbis**: Correção de processos agendadores duplicados que persistiam no servidor após atualizações de código.
- **Blindagem de Git**: Remoção de arquivos de estrutura SQL gerados automaticamente (`*_structure.sql`) do controle de versão para evitar conflitos de merge em produção.

## [3.1.0] - 2026-03-12

### Adicionado
- **Resiliência Anti-Caos (IA Blindada)**: Implementação de timeouts de 30s no `GeminiService` e tratamento robusto de erros de rede, cota e bloqueios do Cloudflare (429/403).
- **Diagnóstico Transparente**: Em caso de falha, o biógrafo agora avisa explicitamente se a IA capotou, se a cota acabou ou se o site barrou o trator, exibindo o diagnóstico direto no card.
- **Cronologia Visual Corrigida**: Distinção semântica entre pendência inicial (Ícone de Relógio) e reprocessamento manual via varinha (Ícone de Ampulheta).

### Alterado
- **Disfarce de Navegador**: O `ProcessBookmarkJob` agora usa headers de requisição realistas (User-Agent, Accept-Language, Referer) para tentar infiltrar-se em sites protegidos.
- **Limpeza de Palco**: Ao clicar na varinha, o resumo antigo é instantaneamente apagado para dar lugar à nova tentativa.

### Corrigido
- **NoMethodError (Gemini Client)**: Correção da inicialização do cliente Gemini que causava crash ao configurar opções após a criação.
- **Sincronização Turbo**: Garantia de que as mensagens de erro de IA sejam transmitidas instantaneamente para a tela do mestre via Turbo Stream.

## [3.0.0] - 2026-03-12

### Adicionado
- **Varinha Mágica (Reprocessamento Manual)**: Introdução do botão de resumo manual (wand icon) na barra de ações, permitindo ao mestre re-invocar a IA para links travados ou falhos.
- **Internacionalização Soberba (pt-BR)**: O sistema agora fala Português (Brasil) nativamente. Tradução integral de mensagens de erro (ActiveRecord), notificações de sistema e feedbacks de interface.
- **Automação de Deploy (`update.sh`)**: Script para facilitar a vida do mestre, consolidando `git pull`, `bin/setup` e o reinício do serviço num único comando de "preguiça produtiva".
- **Central de Configurações**: Novo painel lateral (Dashboard) para gerenciar o comportamento do biógrafo sem sujar as mãos no código.
- **Incinerador de Links (UrlSanitizer)**: Motor de higienização de URLs que remove rastreadores (UTMs, trackers da Amazon, MetroBYT, etc.) antes de salvar o bookmark.
- **Regras Customizadas**: Suporte a regras globais e por provedor (provider rules) via JSON, permitindo ao mestre caçar trackers de nicho que o ClearURLs ignora.
- **Sincronização Atômica**: Integração profunda com a API do ClearURLs, com atualização semanal automática via `recurring.yml` e carga inicial via `bin/setup`.

### Alterado
- **Faxina Estética (CSS Cleanup)**: Extirpação completa de estilos *inline* no card de links, movendo tudo para o `application.css` com classes semânticas.
- **Ícones de Status Honestos**: O spinner enganoso foi substituído por um relógio amarelo estático para indicar espera, mantendo a integridade visual do sistema.
- **Branding "Configurações"**: Extinção do termo "Cockpit" em favor de "Configurações", alinhando a semântica com a elegância operacional do mestre.

### Corrigido
- **Erro 500 (NameError)**: Corrigida a evocação errada do Job (`ProcessArticleJob` -> `ProcessBookmarkJob`) na ação de resumo manual.
- **Mudez do Rails (Translation Missing)**: Adicionadas traduções ausentes para validações de URLs duplicadas e campos obrigatórios.
- **Address already in use (Fim do Zumbi)**: Identificação e eliminação definitiva de processos órfãos que sequestravam a porta 3000 em ambiente de produção local.
- **NoMethodError (CGI.parse)**: Adicionada a dependência `cgi` no `UrlSanitizer` para evitar crashes durante a limpeza de parâmetros.
- **StatementInvalid (Missing Settings Table)**: Corrigido o fluxo de setup para garantir que a tabela de configurações seja migrada antes do primeiro uso.


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
