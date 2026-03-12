class SyncClearUrlsJob < ApplicationJob
  queue_as :background

  CLEAR_URLS_URL = "https://rules2.clearurls.xyz/data.minify.json"

  def perform
    uri = URI.parse(CLEAR_URLS_URL)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      
      # Salva as regras no banco
      Setting.set("automated_rules", data)
      Setting.set("last_automated_sync_at", Time.current.to_s)
      
      Rails.logger.info "GoiabookLM: ClearURLs rules synchronized successfully."
    else
      Rails.logger.error "GoiabookLM: Failed to sync ClearURLs rules. Status: #{response.code}"
    end
  rescue => e
    Rails.logger.error "GoiabookLM: Error syncing ClearURLs: #{e.message}"
  end
end
