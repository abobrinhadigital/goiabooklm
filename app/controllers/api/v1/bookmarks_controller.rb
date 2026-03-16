class Api::V1::BookmarksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  before_action :require_api_token

  def create
    @bookmark = Bookmark.new(url: params[:url], source: "pessegram")

    if @bookmark.save
      render json: { success: true, message: "O GoiabookLM engoliu a URL. Sumário em andamento...", id: @bookmark.id }, status: :created
    else
      render json: { success: false, errors: @bookmark.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def require_api_token
    token = request.headers["X-Api-Token"] || params[:api_token]
    unless token == (ENV["GOIABOOK_API_TOKEN"] || "damascord_goiaba_2026")
      render json: { error: "Sem convite, sem Goiaba." }, status: :unauthorized
    end
  end
end
