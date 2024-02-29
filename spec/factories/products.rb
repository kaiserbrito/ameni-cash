# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { "Green Tea" }
    code { "GR1" }
    price_cents { 311 }
    currency { "eur" }
  end
end
