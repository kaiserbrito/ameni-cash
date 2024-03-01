# frozen_string_literal: true

# Schema Information
# Table name: carts
# id          :bigint   not null, primary key
# total_cents :integer  default(0), not null
# currency    :string   default("eur"), not null
#
class Cart < ApplicationRecord
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products

  validates :currency, :total_cents, presence: true

  monetize :total_cents, as: :total_price, with_model_currency: :currency
  validates :total_cents, numericality: { greater_than_or_equal_to: 0 }
end
