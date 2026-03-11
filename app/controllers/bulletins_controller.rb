class BulletinsController < ApplicationController
  def show
    # 1. Pegar os 10 não lidos mais ANTIGOS (Status processado OU erro)
    # Usamos .to_a para carregar na memória, senão o update_all limpa a relação da query e some na view!
    @bookmarks = Bookmark.where(status: [1, 2])
                         .where(read: [ false, nil ])
                         .order(created_at: :asc)
                         .limit(10).to_a

    if @bookmarks.empty?
      @digest = "Mestre, seu baú de não lidos está vazio ou todos já foram devidamente escrutinados por mim. Que tal adicionar algo novo para eu julgar?"
      return
    end

    # Separamos os processados (1) para mandar pro Gemini e os com erro (2) apenas para listar
    processed_bookmarks = @bookmarks.select { |b| b.status == 1 }
    failed_bookmarks = @bookmarks.select { |b| b.status == 2 }

    begin
      @digest = GeminiService.generate_digest(processed_bookmarks, "Resumido", failed_bookmarks)


      # 2. Marcar como lido após o sucesso da geração (usando IDs para não afetar o array em memória)
      Bookmark.where(id: @bookmarks.map(&:id)).update_all(read: true, updated_at: Time.current)
    rescue => e
      @digest = "Erro ao gerar o boletim: #{e.message}"
    end
  end
end

