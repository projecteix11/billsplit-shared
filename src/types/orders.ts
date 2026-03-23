// Canonical order types — single source of truth for all repos

export type OrderStatus = 'open' | 'closed' | 'cancelled'
export type KitchenStatus = 'pending' | 'cooking' | 'ready' | 'delivered'
export type PaymentStatus = 'unassigned' | 'assigned' | 'paid'
export type PaymentMethod = 'bizum' | 'apple_pay' | 'google_pay' | 'card' | 'cash'

export interface Order {
  id: string
  tenant_id: string
  table_id: string
  table_number: number
  status: OrderStatus
  subtotal: number
  tax_amount: number
  total: number
  amount_paid: number
  created_at: string
  updated_at: string
  items: OrderItem[]
}

export interface OrderItem {
  id: string
  order_id: string
  dish_id: string | null
  dish_name: string
  dish_price: number
  quantity: number
  notes: string | null
  diner_name: string | null
  kitchen_status: KitchenStatus
  payment_status: PaymentStatus
  customization: OrderItemCustomization | null
  created_at: string
}

// Re-exported from dishes for convenience
import type { OrderItemCustomization } from './dishes'
export type { OrderItemCustomization }

export interface OrderGuest {
  id: string
  order_id: string
  user_id: string | null
  guest_name: string
  session_token: string
}

export interface Payment {
  id: string
  order_id: string
  guest_id: string | null
  amount: number
  tip_amount: number
  total_charged: number
  payment_method: PaymentMethod
  status: 'pending' | 'confirmed' | 'failed'
  bizum_reference: string | null
}

export type NewOrderItem = {
  dish_id?: string
  dish_name: string
  dish_price: number
  quantity: number
  notes?: string
  diner_name?: string
  customization?: OrderItemCustomization
}
