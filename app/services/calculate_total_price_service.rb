# frozen_string_literal: true

#
# Service to calculate the total price of a products cart
# It returns a Failure response in case of error or the value of the total price in case of success
# It uses the products cart's product and its quantities and the promotions to apply the discounts
#
class CalculateTotalPriceService
  class Error < StandardError; end

  def initialize(cart_product_id:)
    @cart_product_id = cart_product_id
  end

  # Calculates the total price of the product cart, including any applicable promotions.
  #
  # @return [Integer] The total price in cents
  # @raise [Error] If the calculation fails
  def call
    ActiveRecord::Base.transaction do
      update_total_price

      cart_product.reload.total_cents
    end
  rescue ActiveRecord::RecordNotFound => e
    raise Error, "Failed to calculate total price: #{e.message}"
  end

  private

  attr_reader :cart_product_id

  def update_total_price
    total_price = if promotions.present?
                    calculate_price_with_promotion
                  else
                    cart_product.quantity * product.price_cents
                  end

    cart_product.update!(total_cents: total_price)
  end

  def calculate_price_with_promotion
    promotions.map do |promotion|
      promotion.apply(products_cart.quantity, product.price_cents)
    end.sum
  end

  def cart_product
    @cart_product ||= CartProduct.find(cart_product_id)
  end

  def product
    @product ||= cart_product.product
  end

  def promotions
    @promotions ||= product.promotions
  end
end
