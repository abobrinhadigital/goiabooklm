class FixFtsTriggers < ActiveRecord::Migration[8.1]
  def up
    # Mata os triggers antigos que referenciam 'content' (coluna deletada)
    execute "DROP TRIGGER IF EXISTS bookmarks_ai"
    execute "DROP TRIGGER IF EXISTS bookmarks_ad"
    execute "DROP TRIGGER IF EXISTS bookmarks_au"
    execute "DROP TABLE IF EXISTS bookmarks_search"

    # Recria a tabela FTS5 usando 'summary' no lugar de 'content'
    execute <<-SQL
      CREATE VIRTUAL TABLE bookmarks_search USING fts5(
        title,
        summary,
        content='bookmarks',
        content_rowid='id'
      );
    SQL

    # Novos triggers apontando para 'summary'
    execute <<-SQL
      CREATE TRIGGER bookmarks_ai AFTER INSERT ON bookmarks BEGIN
        INSERT INTO bookmarks_search(rowid, title, summary) VALUES (new.id, new.title, new.summary);
      END;
    SQL

    execute <<-SQL
      CREATE TRIGGER bookmarks_ad AFTER DELETE ON bookmarks BEGIN
        INSERT INTO bookmarks_search(bookmarks_search, rowid, title, summary) VALUES('delete', old.id, old.title, old.summary);
      END;
    SQL

    execute <<-SQL
      CREATE TRIGGER bookmarks_au AFTER UPDATE ON bookmarks BEGIN
        INSERT INTO bookmarks_search(bookmarks_search, rowid, title, summary) VALUES('delete', old.id, old.title, old.summary);
        INSERT INTO bookmarks_search(rowid, title, summary) VALUES (new.id, new.title, new.summary);
      END;
    SQL
  end

  def down
    # (Opcional) Reverter para o estado quebrado não é o ideal, mas aqui apenas limpamos
    execute "DROP TRIGGER IF EXISTS bookmarks_ai"
    execute "DROP TRIGGER IF EXISTS bookmarks_ad"
    execute "DROP TRIGGER IF EXISTS bookmarks_au"
    execute "DROP TABLE IF EXISTS bookmarks_search"
  end
end
