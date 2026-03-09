export interface Dish {
  id: string
  tenant_id: string
  category_id: string | null
  name: string
  price: number
  image: string | null
  is_featured: boolean
  is_available: boolean
}

export interface DishCategory {
  id: string
  tenant_id: string
  name: string
  sort_order: number
}
