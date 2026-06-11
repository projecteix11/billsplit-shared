-- Daily Menus (Menús del día)
-- Run this migration in Supabase SQL Editor

-- daily_menus: each daily menu offering (e.g., "Menú entre semana")
CREATE TABLE IF NOT EXISTS daily_menus (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   uuid,
  name        text NOT NULL,
  description text,
  price       numeric(10,2) NOT NULL DEFAULT 0,
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

-- daily_menu_sections: configurable sections within a menu (e.g., "Primer plato", "Postre")
CREATE TABLE IF NOT EXISTS daily_menu_sections (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_id     uuid NOT NULL REFERENCES daily_menus(id) ON DELETE CASCADE,
  name        text NOT NULL,
  sort_order  int NOT NULL DEFAULT 0,
  max_choices int NOT NULL DEFAULT 1
);

-- daily_menu_items: dishes within a section (linked to carta OR freeform)
CREATE TABLE IF NOT EXISTS daily_menu_items (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  section_id        uuid NOT NULL REFERENCES daily_menu_sections(id) ON DELETE CASCADE,
  dish_id           uuid REFERENCES dishes(id) ON DELETE SET NULL,
  name              text NOT NULL,
  description       text,
  supplement_price  numeric(10,2) NOT NULL DEFAULT 0,
  sort_order        int NOT NULL DEFAULT 0
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_daily_menu_sections_menu_id ON daily_menu_sections(menu_id);
CREATE INDEX IF NOT EXISTS idx_daily_menu_items_section_id ON daily_menu_items(section_id);

-- RLS
ALTER TABLE daily_menus ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_menu_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_menu_items ENABLE ROW LEVEL SECURITY;

-- Menu data is public by design (it is the restaurant's menu), so reads stay
-- open. Writes go through the API (service_role bypasses RLS) — the old
-- `*_auth_all USING (true)` policies also applied to anon and are removed.
-- See manegement/supabase/migrations/20260611100000_rls_lockdown_financial_tables.sql

DROP POLICY IF EXISTS "daily_menus_auth_all"         ON daily_menus;
DROP POLICY IF EXISTS "daily_menu_sections_auth_all" ON daily_menu_sections;
DROP POLICY IF EXISTS "daily_menu_items_auth_all"    ON daily_menu_items;

DROP POLICY IF EXISTS "daily_menus_public_read"         ON daily_menus;
DROP POLICY IF EXISTS "daily_menu_sections_public_read" ON daily_menu_sections;
DROP POLICY IF EXISTS "daily_menu_items_public_read"    ON daily_menu_items;

CREATE POLICY "daily_menus_public_read" ON daily_menus FOR SELECT USING (true);
CREATE POLICY "daily_menu_sections_public_read" ON daily_menu_sections FOR SELECT USING (true);
CREATE POLICY "daily_menu_items_public_read" ON daily_menu_items FOR SELECT USING (true);

-- Realtime (optional)
DO $$ BEGIN ALTER PUBLICATION supabase_realtime ADD TABLE daily_menus;
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
