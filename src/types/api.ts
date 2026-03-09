export interface ApiResponse<T> {
  data: T | null
  error: string | null
}

export type IBillsplitWindow = Window & {
  __BILLSPLIT__: {
    web: string
    api: string
    env: string
  }
}
