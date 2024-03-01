# frozen_string_literal: true

FactoryBot.define do
  factory :cart_product do
    association :product, factory: :product
    association :cart, factory: :cart
    quantity { 1 }
    total_cents { 1000 }
    currency { 'eur' }
  end
end
