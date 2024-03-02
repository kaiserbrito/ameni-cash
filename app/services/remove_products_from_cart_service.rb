# frozen_string_literal: true

# Service responsible for removing products from a cart and updating the total price of the cart.
#
class RemoveProductsFromCartService
  include ActionView::Helpers::TextHelper

  class Error < StandardError; end

  ServiceResponse = Struct.new(:success, :message)

  # Initializes the service with the necessary parameters.
  #
  # @param cart_product_id [Integer] The ID of the cart product to be removed from the cart.
  # @param quantity [Integer] The quantity of the product to be removed (default is 1).
  #
  def initialize(cart_id:, cart_product_id:, quantity: 1)
    @cart_id = cart_id
    @cart_product_id = cart_product_id
    @quantity = quantity
  end

  # Executes the service operation.
  #
  # @return [ServiceResponse] An object indicating the success of the operation and a message.
  #
  def call
    ActiveRecord::Base.transaction do
      validate_cart_product_quantity
      remove_products_from_cart
      update_total_price
    end

    ServiceResponse.new(success: true, message: "#{'Product'.pluralize(quantity)} removed from cart successfully.")
  rescue ActiveRecord::RecordNotFound, Error => e
    ServiceResponse.new(success: false, message: "Failed to remove product from cart: #{e.message}")
  rescue CalculateTotalPriceService::Error => e
    ServiceResponse.new(success: false, message: "Failed to update total price: #{e.message}")
  end

  private

  attr_reader :cart_id, :cart_product_id, :quantity

  def validate_cart_product_quantity
    return if cart_product.quantity >= quantity

    raise Error, "Validation failed: Quantity must be less than or equal to #{cart_product.quantity}"
  end

  def remove_products_from_cart
    return cart_product.destroy if cart_product.quantity == quantity

    cart_product.quantity -= quantity
    cart_product.save!
  end

  def update_total_price
    return cart.destroy if cart_products.blank?

    total_cents = cart_products.map do |cart_product|
      CalculateTotalPriceService.new(cart_product_id: cart_product.id).call
    end.sum

    cart.update!(total_cents:)
  end

  def cart_product
    @cart_product ||= CartProduct.find(cart_product_id)
  end

  def cart
    @cart ||= Cart.find(cart_id)
  end

  def cart_products
    @cart_products ||= cart.reload.cart_products
  end
end
