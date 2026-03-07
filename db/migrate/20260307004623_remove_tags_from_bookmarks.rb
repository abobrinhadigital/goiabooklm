class RemoveTagsFromBookmarks < ActiveRecord::Migration[8.1]
  def change
    remove_column :bookmarks, :tags, :string
  end
end
