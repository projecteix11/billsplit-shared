export type UserRole = 'admin' | 'editor' | 'waiter' | 'user' | 'superadmin'

export interface AuthUser {
  id: string
  email: string | undefined
  full_name: string | null
  role: UserRole
  tenant_id: string
}

export interface AuthSession {
  access_token: string
  refresh_token: string
  expires_at: number
}
