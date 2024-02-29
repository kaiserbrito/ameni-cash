# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    code { Faker::Commerce.promotion_code }
    price_cents { Faker::Number.number(digits: 4) }
    currency { 'eur' }
  end
end
