export const API_ROUTES = {
  // Dishes (menu)
  dishes:               '/api/dishes',
  categories:           '/api/categories',

  // Orders
  createOrder:          '/api/orders',
  getOrder:             (id: string) => `/api/orders/${id}`,
  getOpenOrderForTable: (tableId: string) => `/api/tables/${tableId}/open-order`,
  addItemsToOrder:      (id: string) => `/api/orders/${id}/items`,
  closeOrder:           (id: string) => `/api/orders/${id}/close`,
  listOrders:           '/api/orders',

  // Order items
  updateKitchenStatus:  (itemId: string) => `/api/order-items/${itemId}/kitchen-status`,
  updatePaymentStatus:  '/api/order-items/payment-status',

  // Payments
  createPayment:        '/api/payments',
  redsysSign:           '/api/payments/redsys-sign',
} as const
