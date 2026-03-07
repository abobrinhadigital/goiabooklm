class CreateBookmarks < ActiveRecord::Migration[8.1]
  def change
    create_table :bookmarks do |t|
      t.string :url
      t.string :title
      t.text :description
      t.text :content
      t.text :summary
      t.string :tags
      t.integer :status
      t.boolean :read

      t.timestamps
    end
  end
end
