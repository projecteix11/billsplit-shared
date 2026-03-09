import { QR_EXPIRY_MINUTES } from '../config/constants'

export { QR_EXPIRY_MINUTES }

export function isQrExpired(expiresAt: string): boolean {
  return new Date(expiresAt) < new Date()
}

export function generateSessionToken(): string {
  return crypto.randomUUID()
}
