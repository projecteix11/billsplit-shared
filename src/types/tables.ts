export type TableStatus = 'available' | 'reserved' | 'on-dine'
export type TableSize = 'small' | 'large'
export type Rotation = 0 | 90 | 180 | 270

export interface RestaurantTable {
  id: string
  number: number
  zone: string
  status: TableStatus
  seats: number
  occupants: number
  size: TableSize
  gridCol: number
  gridRow: number
  colSpan: number
  rowSpan: number
  rotation: Rotation
  mergedFrom?: number[]
}
