# frozen_string_literal: true

# Create products
products_to_create = [
  {
    name: 'Green Tea',
    code: 'GR1',
    price_cents: 311
  },
  {
    name: 'Strawberries',
    code: 'SR1',
    price_cents: 500
  },
  {
    name: 'Coffee',
    code: 'CF1',
    price_cents: 1123
  }
]

puts 'Creating products'
Product.insert_all(products_to_create)
puts 'Products created'
