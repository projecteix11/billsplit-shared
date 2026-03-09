export type Locale = 'en' | 'es' | 'ca' | 'fr' | 'de' | 'it'

export interface Language {
  code: string
  name: string
  flag: string
  available: boolean
}
