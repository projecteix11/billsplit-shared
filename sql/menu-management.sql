-- ============================================================================
-- BillSplit: Menu Management - Database Migration
-- Adapted to the REAL Supabase schema
-- Run this in Supabase SQL Editor
-- ============================================================================

-- ── 1. Add emoji icon column to allergens ────────────────────────────────────
-- (the existing icon_url is for image URLs; this is for emoji display)

ALTER TABLE allergens ADD COLUMN IF NOT EXISTS icon TEXT;

-- Seed emoji icons for the 14 EU mandatory allergens (exact slugs from DB)
UPDATE allergens SET icon = '🌾' WHERE slug = 'gluten'      AND icon IS NULL;
UPDATE allergens SET icon = '🦀' WHERE slug = 'crustaceans' AND icon IS NULL;
UPDATE allergens SET icon = '🥚' WHERE slug = 'eggs'        AND icon IS NULL;
UPDATE allergens SET icon = '🐟' WHERE slug = 'fish'        AND icon IS NULL;
UPDATE allergens SET icon = '🥜' WHERE slug = 'peanuts'     AND icon IS NULL;
UPDATE allergens SET icon = '🫘' WHERE slug = 'soy'         AND icon IS NULL;
UPDATE allergens SET icon = '🥛' WHERE slug = 'dairy'       AND icon IS NULL;
UPDATE allergens SET icon = '🌰' WHERE slug = 'nuts'        AND icon IS NULL;
UPDATE allergens SET icon = '🥬' WHERE slug = 'celery'      AND icon IS NULL;
UPDATE allergens SET icon = '🟡' WHERE slug = 'mustard'     AND icon IS NULL;
UPDATE allergens SET icon = '⚪' WHERE slug = 'sesame'      AND icon IS NULL;
UPDATE allergens SET icon = '🍷' WHERE slug = 'sulphites'   AND icon IS NULL;
UPDATE allergens SET icon = '🌿' WHERE slug = 'lupin'       AND icon IS NULL;
UPDATE allergens SET icon = '🐚' WHERE slug = 'molluscs'    AND icon IS NULL;

-- ── 2. Create custom_dishes table (special requests per table) ───────────────

CREATE TABLE IF NOT EXISTS custom_dishes (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   uuid,
  table_id    text    NOT NULL,
  name        text    NOT NULL,
  description text,
  price       numeric(10,2) NOT NULL DEFAULT 0,
  notes       text,
  created_by  uuid,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_custom_dishes_table_id
  ON custom_dishes(table_id);

-- ── 3. Add customization columns to order_items ──────────────────────────────

ALTER TABLE order_items
  ADD COLUMN IF NOT EXISTS dish_id       uuid REFERENCES dishes(id),
  ADD COLUMN IF NOT EXISTS customization jsonb;

-- customization stores: { "added_ingredients": [...], "removed_ingredients": [...] }

-- ── 4. RLS for new tables ────────────────────────────────────────────────────

ALTER TABLE custom_dishes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "custom_dishes_public_read" ON custom_dishes
  FOR SELECT USING (true);

CREATE POLICY "custom_dishes_auth_insert" ON custom_dishes
  FOR INSERT WITH CHECK (true);

CREATE POLICY "custom_dishes_auth_delete" ON custom_dishes
  FOR DELETE USING (true);

-- ── 5. Enable realtime ───────────────────────────────────────────────────────

-- dishes and dish_ingredients may already be in the publication; ignore errors
DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE dishes;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE dish_ingredients;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE custom_dishes;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;
