CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE "solid_cable_messages" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "channel" varchar NOT NULL, "payload" text NOT NULL, "created_at" datetime(6) NOT NULL);
CREATE INDEX "index_solid_cable_messages_on_channel" ON "solid_cable_messages" ("channel") /*application='Goiabooklm'*/;
CREATE INDEX "index_solid_cable_messages_on_created_at" ON "solid_cable_messages" ("created_at") /*application='Goiabooklm'*/;
INSERT INTO "schema_migrations" (version) VALUES
('20260311210000');

