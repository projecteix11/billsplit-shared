export type ToastVariant = 'success' | 'error' | 'warning' | 'info'

export interface Toast {
  id: string
  variant: ToastVariant
  titleKey: string
  descriptionKey?: string
  params?: Record<string, string | number>
  duration: number
  createdAt: number
}

export type ToastInput = Omit<Toast, 'id' | 'createdAt' | 'duration'> & {
  duration?: number
}

export type NotificationType = 'order_received' | 'order_ready'

export interface AppNotification {
  id: string
  type: NotificationType
  titleKey: string
  descriptionKey?: string
  params?: Record<string, string | number>
  read: boolean
  createdAt: number
}

export type AppNotificationInput = Omit<AppNotification, 'id' | 'read' | 'createdAt'>
