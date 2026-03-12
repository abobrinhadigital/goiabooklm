class Bookmark < ApplicationRecord
  validates :url, presence: true, uniqueness: true

  # Sanitiza a URL antes da validação
  before_validation :sanitize_url

  # Set default values before validation
  after_initialize :set_defaults, if: :new_record?

  # Trigger the background job after creation
  after_commit :enqueue_processing, on: :create

  def self.search(query)
    return all if query.blank?

    # Busca case-insensitive usando LIKE para garantir que o mestre encontre as abobrinhas dele
    # SQLite LIKE é case-insensitive por padrão para caracteres ASCII.
    # Usamos LOWER para garantir consistência em diferentes ambientes.
    where("LOWER(title) LIKE :q OR LOWER(summary) LIKE :q OR LOWER(url) LIKE :q",
          q: "%#{query.downcase}%")
      .order(created_at: :desc)
  end

  private

  def sanitize_url
    self.url = UrlSanitizer.call(self.url) if self.url.present?
  end

  def set_defaults
    self.status ||= 0
    self.read ||= false
  end

  def enqueue_processing
    ProcessBookmarkJob.perform_later(self.id)
  end
end
