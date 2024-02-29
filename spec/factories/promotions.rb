# frozen_string_literal: true

FactoryBot.define do
  factory :promotion do
    association :product
    name { 'Buy one get one free' }
    discount { 100 }
    quantity { 2 }
  end
end
