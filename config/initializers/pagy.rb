# frozen_string_literal: true

require 'pagy'
require 'pagy/backend'
require 'pagy/frontend'
require 'pagy/extras/overflow'

# Configurações para Pagy v9.4.0
Pagy::DEFAULT[:limit]    = 10
Pagy::DEFAULT[:overflow] = :last_page


