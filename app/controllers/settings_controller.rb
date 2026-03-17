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

  def edit_prompts
    summary_path = Rails.root.join("config", "prompts", "summary_prompt.md")
    digest_path = Rails.root.join("config", "prompts", "digest_prompt.md")

    # Garantir que o diretório exista
    FileUtils.mkdir_p(File.dirname(summary_path))

    @summary_prompt = File.exist?(summary_path) ? File.read(summary_path) : "## Prompt de Resumo\n\n[AVISO DO POLLUX]: O arquivo original não foi encontrado no servidor. Por favor, re-escreva ou cole o prompt aqui, mestre."
    @digest_prompt = File.exist?(digest_path) ? File.read(digest_path) : "## Prompt de Boletim\n\n[AVISO DO POLLUX]: O arquivo original não foi encontrado no servidor. Por favor, re-escreva ou cole o prompt aqui, mestre."
  end

  def update_prompts
    summary_content = params[:summary_prompt]
    digest_content = params[:digest_prompt]

    begin
      File.write(Rails.root.join("config", "prompts", "summary_prompt.md"), summary_content)
      File.write(Rails.root.join("config", "prompts", "digest_prompt.md"), digest_content)
      redirect_to settings_edit_prompts_path, notice: "Prompts do Pollux atualizados com sucesso no disco, mestre!"
    rescue => e
      flash.now[:alert] = "Não consegui escrever nos arquivos, mestre. Verifique as permissões: #{e.message}"
      @summary_prompt = summary_content
      @digest_prompt = digest_content
      render :edit_prompts, status: :unprocessable_entity
    end
  end
end
