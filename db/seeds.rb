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
  product: strawberries
)
puts "Promotion for '#{strawberries.name}' created"
puts '===================='

coffee = Product.find_or_create_by!(name: 'Coffee', code: 'CF1', price_cents: 1123)
puts "Product #{coffee.name} created"
puts 'Creating promotion'
Promotion.find_or_create_by!(
  name: 'Coffee addiction',
  discount: 33,
  quantity: 3,
  product: coffee
)
puts "Promotion for '#{coffee.name}' created"
puts '===================='
