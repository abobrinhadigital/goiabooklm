class CreateBookmarksSearch < ActiveRecord::Migration[8.1]
  def up
    # Cria a tabela virtual do FTS5 ligada à tabela bookmarks real
    execute <<-SQL
      CREATE VIRTUAL TABLE bookmarks_search USING fts5(
        title,#{' '}
        content,#{' '}
        content='bookmarks',#{' '}
        content_rowid='id'
      );
    SQL

    # Triggers para manter o índice de busca sempre atualizado automaticamente pelo SQLite
    execute <<-SQL
      CREATE TRIGGER bookmarks_ai AFTER INSERT ON bookmarks BEGIN
        INSERT INTO bookmarks_search(rowid, title, content) VALUES (new.id, new.title, new.content);
      END;
    SQL

    execute <<-SQL
      CREATE TRIGGER bookmarks_ad AFTER DELETE ON bookmarks BEGIN
        INSERT INTO bookmarks_search(bookmarks_search, rowid, title, content) VALUES('delete', old.id, old.title, old.content);
      END;
    SQL

    execute <<-SQL
      CREATE TRIGGER bookmarks_au AFTER UPDATE ON bookmarks BEGIN
        INSERT INTO bookmarks_search(bookmarks_search, rowid, title, content) VALUES('delete', old.id, old.title, old.content);
        INSERT INTO bookmarks_search(rowid, title, content) VALUES (new.id, new.title, new.content);
      END;
    SQL
  end

  def down
    execute "DROP TRIGGER IF EXISTS bookmarks_ai"
    execute "DROP TRIGGER IF EXISTS bookmarks_ad"
    execute "DROP TRIGGER IF EXISTS bookmarks_au"
    execute "DROP TABLE IF EXISTS bookmarks_search"
  end
end
