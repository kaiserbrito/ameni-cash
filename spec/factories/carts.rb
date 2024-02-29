# frozen_string_literal: true

FactoryBot.define do
  factory :cart do
    total_cents { Faker::Number.number(digits: 4) }
    currency { 'eur' }
  end
end
