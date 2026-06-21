import type { AppRoute } from './routes.js'

export interface NavItem {
  key: string
  labelKey: string
  routeName: AppRoute
  icon: string
  badge?: number
}
