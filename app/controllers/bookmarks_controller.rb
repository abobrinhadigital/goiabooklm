class BookmarksController < ApplicationController
  before_action :set_bookmark, only: %i[ show edit update destroy toggle_read toggle_favorite summarize ]

  # GET /bookmarks or /bookmarks.json
  def index
    @bookmarks = Bookmark.search(params[:query]).order(created_at: :desc)
    @bookmarks = @bookmarks.where(read: [ false, nil ]) if params[:unread] == "true"
    @bookmarks = @bookmarks.where(favorite: true) if params[:favorites] == "true"
    @pagy, @bookmarks = pagy(@bookmarks)
  end

  # GET /bookmarks/1 or /bookmarks/1.json
  def show
  end

  # GET /bookmarks/new
  def new
    @bookmark = Bookmark.new
  end

  # GET /bookmarks/1/edit
  def edit
  end

  # POST /bookmarks or /bookmarks.json
  def create
    @bookmark = Bookmark.new(bookmark_params)

    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to bookmarks_path, notice: t('bookmarks.created') }
        format.turbo_stream { redirect_to bookmarks_path, notice: t('bookmarks.created') }
        format.json { render :show, status: :created, location: @bookmark }
      else
        error_msg = "Erro ao salvar: #{@bookmark.errors.full_messages.to_sentence}"
        format.html { redirect_to bookmarks_path, alert: error_msg }
        format.turbo_stream { redirect_to bookmarks_path, alert: error_msg }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookmarks/1 or /bookmarks/1.json
  def update
    respond_to do |format|
      if @bookmark.update(bookmark_params)
        format.html { redirect_to bookmarks_path, notice: t('bookmarks.updated'), status: :see_other }
        format.json { render :show, status: :ok, location: @bookmark }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1 or /bookmarks/1.json
  def destroy
    @bookmark.destroy!

    respond_to do |format|
      format.html { redirect_to bookmarks_path, notice: t('bookmarks.destroyed'), status: :see_other }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /bookmarks/1/toggle_favorite
  def toggle_favorite
    @bookmark.update(favorite: !@bookmark.favorite)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@bookmark) }
      format.html { redirect_to bookmarks_path, notice: "Favorito atualizado." }
      format.json { render :show, status: :ok, location: @bookmark }
    end
  end

  # PATCH/PUT /bookmarks/1/toggle_read
  def toggle_read
    @bookmark.update(read: !@bookmark.read)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@bookmark) }
      format.html { redirect_to bookmarks_path, notice: "Status de leitura atualizado." }
      format.json { render :show, status: :ok, location: @bookmark }
    end
  end

  # POST /bookmarks/1/summarize
  def summarize
    @bookmark.update(status: 3, summary: nil)
    ProcessBookmarkJob.perform_later(@bookmark.id)
    
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@bookmark) }
      format.html { redirect_to bookmarks_path, notice: t('bookmarks.summary_requested') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def bookmark_params
      params.expect(bookmark: [ :url, :title, :description, :summary, :tags, :status, :read, :favorite ])
    end
end
