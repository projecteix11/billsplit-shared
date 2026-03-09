import type { OrderItem } from '../types/orders'

export function formatPrice(amount: number, currency = 'EUR'): string {
  return new Intl.NumberFormat('es-ES', {
    style: 'currency',
    currency,
  }).format(amount)
}

export function calculateSubtotal(items: Pick<OrderItem, 'dish_price' | 'quantity'>[]): number {
  return items.reduce((sum, item) => sum + item.dish_price * item.quantity, 0)
}

export function calculateTax(subtotal: number, taxRate: number): number {
  return Math.round((subtotal * taxRate / 100) * 100) / 100
}

export function calculateTotal(subtotal: number, taxAmount: number): number {
  return Math.round((subtotal + taxAmount) * 100) / 100
}
