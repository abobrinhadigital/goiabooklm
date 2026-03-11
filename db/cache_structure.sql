CREATE TABLE IF NOT EXISTS "solid_cache_entries" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "key" BLOB NOT NULL,
  "value" BLOB NOT NULL,
  "created_at" DATETIME NOT NULL,
  "key_hash" INTEGER NOT NULL,
  "byte_size" INTEGER NOT NULL
);
CREATE INDEX "index_solid_cache_entries_on_byte_size" ON "solid_cache_entries" ("byte_size");
CREATE INDEX "index_solid_cache_entries_on_key_hash_and_byte_size" ON "solid_cache_entries" ("key_hash", "byte_size");
CREATE UNIQUE INDEX "index_solid_cache_entries_on_key_hash" ON "solid_cache_entries" ("key_hash");
