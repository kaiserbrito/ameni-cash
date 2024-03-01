# frozen_string_literal: true

# Schema Information
# Table name: cart_products
# id          :bigint  not null, primary key
# quantity    :integer not null
# total_cents :integer default(0), not null
# currency    :string  default("eur"), not null
# product_id  :bigint  not null
# cart_id     :bigint  not null
#
class CartProduct < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates :currency, :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :total_cents, numericality: { greater_than_or_equal_to: 0 }

  monetize :total_cents, as: :total_price, with_model_currency: :currency
end
