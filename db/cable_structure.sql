CREATE TABLE IF NOT EXISTS "solid_cable_messages" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "channel" BLOB NOT NULL,
  "payload" BLOB NOT NULL,
  "created_at" DATETIME NOT NULL,
  "channel_hash" INTEGER NOT NULL
);
CREATE INDEX "index_solid_cable_messages_on_channel" ON "solid_cable_messages" ("channel");
CREATE INDEX "index_solid_cable_messages_on_channel_hash" ON "solid_cable_messages" ("channel_hash");
CREATE INDEX "index_solid_cable_messages_on_created_at" ON "solid_cable_messages" ("created_at");
