# frozen_string_literal: true

# Schema Information
# Table name: promotions
# id             :bigint  not null, primary key
# name           :string  not null
# discount       :integer not null
# discount_type  :enum not null - type of discount, can be fixed or percentage or bogo
# quantity       :integer not null - number of products that need to be in the cart for the promotion to apply
# product_id     :bigint  not null
#
class Promotion < ApplicationRecord
  belongs_to :product

  validates :name, :discount, :quantity, presence: true
  validates :discount, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than: 1 }

  enum :discount_type, {
    bogo: 'bogo', # buy-one-get-one
    fixed: 'fixed',
    percentage: 'percentage'
  }, _default: 'bogo'

  # Checks if the promotion is applicable based on the quantity of products in the cart
  #
  # @param quantity [Integer] Quantity of products in the cart
  # @return [Boolean] True if the promotion is applicable, otherwise false
  def applicable?(quantity)
    quantity >= self.quantity
  end
end
