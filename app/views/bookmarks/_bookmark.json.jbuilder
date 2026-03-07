json.extract! bookmark, :id, :url, :title, :description, :content, :summary, :tags, :status, :read, :created_at, :updated_at
json.url bookmark_url(bookmark, format: :json)
