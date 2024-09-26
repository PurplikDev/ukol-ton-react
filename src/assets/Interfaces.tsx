export interface Product {
      id: number,
      product_code: string,
      name: string,
      product_type: string,
      default_price_list_id: number,
      model_file_url: string,
      model_file_name: string,
      alternatives_group_id: number
  }
  
export interface Result {
      products: Product[],
      last_modified_when: Date
      checksum: string
}