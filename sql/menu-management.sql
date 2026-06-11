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

-- ── 3. Add ingredient choice limits to dishes ────────────────────────────────
-- max_included_choices: max number of default (included) ingredients the client can select
--   NULL = unlimited (all included)
-- max_extra_choices: max number of paid extras the client can add
--   NULL = unlimited

ALTER TABLE dishes
  ADD COLUMN IF NOT EXISTS max_included_choices integer DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS max_extra_choices    integer DEFAULT NULL;

-- ── 4. Add customization columns to order_items ──────────────────────────────

ALTER TABLE order_items
  ADD COLUMN IF NOT EXISTS dish_id       uuid REFERENCES dishes(id),
  ADD COLUMN IF NOT EXISTS customization jsonb;

-- customization stores: { "added_ingredients": [...], "removed_ingredients": [...] }

-- ── 5. RLS for new tables ────────────────────────────────────────────────────
-- Staff read their own tenant's rows; all writes go through the API
-- (service_role bypasses RLS). anon has no access: `notes` holds free-text
-- special requests (personal data) and must not be world-readable.
-- Superseded the old USING (true) policies — see
-- manegement/supabase/migrations/20260611100000_rls_lockdown_financial_tables.sql

ALTER TABLE custom_dishes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "custom_dishes_public_read"  ON custom_dishes;
DROP POLICY IF EXISTS "custom_dishes_auth_insert"  ON custom_dishes;
DROP POLICY IF EXISTS "custom_dishes_auth_delete"  ON custom_dishes;
DROP POLICY IF EXISTS "custom_dishes_staff_select" ON custom_dishes;

-- LIVE-SCHEMA NOTE: the production table has no tenant_id column (drifted from
-- the CREATE TABLE above), so tenant scope comes from table_id -> restaurant_tables.
CREATE POLICY "custom_dishes_staff_select" ON custom_dishes
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.restaurant_tables rt
    WHERE rt.id = public.safe_cast_uuid(custom_dishes.table_id::text)
      AND rt.tenant_id IN (SELECT public.get_my_tenant_ids())
  ));

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
