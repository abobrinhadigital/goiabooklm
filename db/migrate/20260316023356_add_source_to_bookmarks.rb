class AddSourceToBookmarks < ActiveRecord::Migration[8.1]
  def change
    add_column :bookmarks, :source, :string, default: "web"
    add_index :bookmarks, :source
  end
end
