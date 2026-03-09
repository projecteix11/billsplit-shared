export const ORDER_STATUS = {
  OPEN: 'open',
  CLOSED: 'closed',
  CANCELLED: 'cancelled',
} as const

export const KITCHEN_STATUS = {
  PENDING: 'pending',
  COOKING: 'cooking',
  READY: 'ready',
  DELIVERED: 'delivered',
} as const

export const PAYMENT_METHOD = {
  BIZUM: 'bizum',
  APPLE_PAY: 'apple_pay',
  GOOGLE_PAY: 'google_pay',
  CARD: 'card',
  CASH: 'cash',
} as const

export const TAX_RATES = {
  ES: 10,
  DEFAULT: 21,
} as const

export const QR_EXPIRY_MINUTES = 480 // 8 hours

export const PAYMENT_PENDING_TIMEOUT_MS = 15 * 60 * 1000 // 15 min
