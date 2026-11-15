import { http } from './http'

export interface ProductCard {
  id: number
  externalId: string
  name: string
  company: string
  categoryId: number
  categoryName: string
  productType: string
  minAge: number | null
  maxAge: number | null
  minPremium: number | null
  maxPremium: number | null
  periodDesc: string
  waitingDays: number | null
  guaranteedRenewal: boolean | null
  highlights: string
  dataStatus: string
  verifiedFrom: string
  coverImageUrl: string
  priceDisplay: string
  priceStatus: string
  labels: string[]
}

export interface PageResult<T> {
  records: T[]
  total: number
  page: number
  size: number
}

export interface ProductQuery {
  categoryId?: number
  age?: number
  keyword?: string
  sort?: string
  page?: number
  size?: number
}

export interface ClauseInfo {
  docId: string
  clauseName: string
  fileType: string
  pageCount: number
  status: string
  regNo: string
}

export interface ProductDetail extends ProductCard {
  paymentTerm: string
  coverageTerm: string
  saleStatus: string
  registrationNo: string
  issuerType: string
  sourceUrl: string
  clauses: ClauseInfo[]
}

export interface CompareRow {
  field: string
  label: string
  values: string[]
}

export interface CompareResult {
  products: ProductCard[]
  rows: CompareRow[]
}

export interface CategoryNode {
  id: number
  code: string
  name: string
  level: number
  children: CategoryNode[]
}

export const fetchProducts = (q: ProductQuery) => http.get<never, PageResult<ProductCard>>('/products', { params: q })

export const fetchProduct = (id: number) => http.get<never, ProductDetail>(`/products/${id}`)

export const fetchCompare = (ids: number[]) =>
  http.post<never, CompareResult>('/products/compare', { ids })

export const fetchCategories = () => http.get<never, CategoryNode[]>('/categories/tree')
