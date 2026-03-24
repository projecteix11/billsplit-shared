export const API_ROUTES = {
  // Dishes (menu)
  dishes:               '/api/dishes',
  dish:                 (id: string) => `/api/dishes/${id}`,
  dishAllergens:        (id: string) => `/api/dishes/${id}/allergens`,
  dishIngredients:      (id: string) => `/api/dishes/${id}/ingredients`,
  dishIngredient:       (dishId: string, ingId: string) => `/api/dishes/${dishId}/ingredients/${ingId}`,
  categories:           '/api/categories',
  allergens:            '/api/allergens',

  // Custom dishes (special requests per table)
  customDishes:         '/api/custom-dishes',
  tableCustomDishes:    (tableId: string) => `/api/tables/${tableId}/custom-dishes`,

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
