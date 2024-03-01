# frozen_string_literal: true

# Schema Information
# Table name: products
# id           :bigint  not null, primary key
# name         :string  not null
# code         :string  not null
# price_cents  :integer not null
# currency     :enum    not null, default("eur")
#
class Product < ApplicationRecord
  has_many :promotions, dependent: :destroy
  has_one :cart_product, dependent: :destroy

  validates :name, :code, :price_cents, presence: true
  validates :code, uniqueness: true
  validates :currency, inclusion: { in: %w[eur gbp usd] }

  monetize :price_cents, with_model_currency: :currency

  enum :currency, { eur: 'eur', gbp: 'gbp', usd: 'usd' }, _default: 'eur'
end
