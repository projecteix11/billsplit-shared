// ── Base dish (DB row) ────────────────────────────────────────────────────────

export interface Dish {
  id: string
  tenant_id: string
  category_id: string | null
  name: string
  description: string | null
  price: number
  image: string | null
  is_featured: boolean
  is_available: boolean
  created_at: string
  updated_at: string
}

export interface DishCategory {
  id: string
  tenant_id: string
  name: string
  sort_order: number
}

// ── Allergens ─────────────────────────────────────────────────────────────────

export interface Allergen {
  id: string
  name: string
  icon: string | null
}

// ── Dish ingredients (customizable per dish) ──────────────────────────────────

export interface DishIngredient {
  id: string
  dish_id: string
  name: string
  is_default: boolean
  extra_price: number
  sort_order: number
}

// ── Full dish with relations (returned by API) ────────────────────────────────

export interface DishFull extends Dish {
  allergens: Allergen[]
  ingredients: DishIngredient[]
}

// ── Custom dish for a specific table (special request) ────────────────────────

export interface CustomDish {
  id: string
  table_id: string
  name: string
  description: string | null
  price: number
  notes: string | null
  created_by: string
  created_at: string
}

// ── DTOs for create/update operations ─────────────────────────────────────────

export interface CreateDishInput {
  name: string
  description?: string
  price: number
  category_id?: string
  image?: string
  is_featured?: boolean
  is_available?: boolean
}

export interface UpdateDishInput {
  name?: string
  description?: string
  price?: number
  category_id?: string | null
  image?: string | null
  is_featured?: boolean
  is_available?: boolean
}

export interface CreateDishIngredientInput {
  name: string
  is_default?: boolean
  extra_price?: number
  sort_order?: number
}

export interface UpdateDishIngredientInput {
  name?: string
  is_default?: boolean
  extra_price?: number
  sort_order?: number
}

export interface CreateCustomDishInput {
  table_id: string
  name: string
  description?: string
  price: number
  notes?: string
}

// ── Selected ingredient in an order item ──────────────────────────────────────

export interface OrderItemIngredient {
  ingredient_id: string
  name: string
  extra_price: number
}

export interface MenuGroupInfo {
  menu_name: string
  section_name: string
  group_id: string
  base_price: number
}

export interface OrderItemCustomization {
  added_ingredients: OrderItemIngredient[]
  removed_ingredients: string[]
  menu_group?: MenuGroupInfo
}
