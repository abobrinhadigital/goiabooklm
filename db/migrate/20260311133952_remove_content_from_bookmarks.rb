class RemoveContentFromBookmarks < ActiveRecord::Migration[8.1]
  def change
    remove_column :bookmarks, :content, :text
  end
end
