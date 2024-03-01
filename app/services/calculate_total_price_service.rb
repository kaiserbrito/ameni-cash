# frozen_string_literal: true

#
# Service to calculate the total price of a products cart
# It returns a Failure response in case of error or the value of the total price in case of success
# It uses the products cart's product and its quantities and the promotions to apply the discounts
#
class CalculateTotalPriceService
  FailureResponse = Struct.new(:success, :message)

  def initialize(products_cart_id:)
    @products_cart_id = products_cart_id
  end

  def call
    calculate_total_price
  rescue ActiveRecord::RecordNotFound => e
    FailureResponse.new(success: false, message: "Failed to calculate total price: #{e.message}")
  end

  private

  attr_reader :products_cart_id

  def calculate_total_price
    total_price = if promotions.present?
                    calculate_price_with_promotion
                  else
                    products_cart.quantity * product.price_cents
                  end

    products_cart.update!(total_cents: total_price)
  end

  def calculate_price_with_promotion
    promotions.map do |promotion|
      promotion.apply(products_cart.quantity, product.price_cents)
    end.sum
  end

  def products_cart
    @products_cart ||= ProductsCart.find(products_cart_id)
  end

  def product
    @product ||= products_cart.product
  end

  def promotions
    @promotions ||= product.promotions
  end
end
