class SettingsController < ApplicationController
  before_action :authenticate_user!

  def edit_rules
    @custom_rules_json = JSON.pretty_generate(Setting.get("custom_rules") || {})
  end

  def update_rules
    json_content = params[:custom_rules_json]
    
    begin
      parsed = JSON.parse(json_content)
      Setting.set("custom_rules", parsed)
      redirect_to settings_edit_rules_path, notice: "Regras customizadas atualizadas com sucesso, mestre!"
    rescue JSON::ParserError => e
      @custom_rules_json = json_content
      flash.now[:alert] = "Mestre, o JSON está inválido: #{e.message}. Corrija a sintaxe para prosseguirmos."
      render :edit_rules, status: :unprocessable_entity
    end
  end

  def global_rules
    @automated_rules = Setting.get("automated_rules") || {}
    @last_sync = Setting.get("last_automated_sync_at")
  end
end
