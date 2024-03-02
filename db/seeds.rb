# frozen_string_literal: true

green_tea = Product.find_or_create_by!(name: 'Green Tea', code: 'GR1', price_cents: 311)
puts "Product #{green_tea.name} created"
puts 'Creating promotion'
Promotion.find_or_create_by!(
  name: 'Buy one get one free',
  discount: 100,
  quantity: 2,
  product: green_tea
)
puts "Promotion for '#{green_tea.name}' created"
puts '===================='

strawberries = Product.find_or_create_by!(name: 'Strawberries', code: 'SR1', price_cents: 500)
puts "Product #{strawberries.name} created"
puts 'Creating promotion'
Promotion.find_or_create_by!(
  name: 'Buy 3 or more and get 10% off each strawberry',
  discount: 50,
  quantity: 3,
  product: strawberries,
  discount_type: 'fixed'
)
puts "Promotion for '#{strawberries.name}' created"
puts '===================='

coffee = Product.find_or_create_by!(name: 'Coffee', code: 'CF1', price_cents: 1123)
puts "Product #{coffee.name} created"
puts 'Creating promotion'
Promotion.find_or_create_by!(
  name: 'Buy 3 or more, the price drops to 2/3 of the original price',
  discount: 66.666,
  quantity: 3,
  product: coffee,
  discount_type: 'percentage'
)
puts "Promotion for '#{coffee.name}' created"
puts '===================='
