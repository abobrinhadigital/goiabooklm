class DigestsController < ApplicationController
  def daily
    @bookmarks = Bookmark.where("created_at >= ?", Time.current.beginning_of_day).where(status: 1)
    begin
      @digest = GeminiService.generate_digest(@bookmarks, "Diário")
    rescue => e
      @digest = "Erro ao gerar o boletim diário: #{e.message}"
    end
  end

  def weekly
    @bookmarks = Bookmark.where("created_at >= ?", 1.week.ago.beginning_of_day).where(status: 1)
    begin
      @digest = GeminiService.generate_digest(@bookmarks, "Semanal")
    rescue => e
      @digest = "Erro ao gerar o boletim semanal: #{e.message}"
    end
  end
end
