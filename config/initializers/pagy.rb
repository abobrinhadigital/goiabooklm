# frozen_string_literal: true

require 'pagy'
require 'pagy/backend'
require 'pagy/frontend'
require 'pagy/extras/overflow'

# See https://ddnexus.github.io/pagy/docs/api/pagy
# Configurações padrões podem ser adicionadas aqui.
Pagy::DEFAULT[:limit]    = 10   # Limite padrão de abobrinhas por página.
Pagy::DEFAULT[:overflow] = :last_page # Se o mestre tentar acessar uma página que não existe mais, manda pra última.


