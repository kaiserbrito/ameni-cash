# frozen_string_literal: true

class AddProductsToCartService
  def initialize(cart_id:, product_id:, quantity: 1)
    @cart_id = cart_id
    @product_id = product_id
    @quantity = quantity
  end

  def call
    ActiveRecord::Base.transaction do
      add_product_to_cart
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error(e.message)
    false
  end

  private

  attr_reader :cart_id, :quantity, :product_id

  def add_product_to_cart
    product_cart = cart.products_carts.find_or_initialize_by(product:)
    product_cart.quantity += quantity
    product_cart.save!
  end

  def cart
    @cart ||= Cart.find(cart_id)
  end

  def product
    @product ||= Product.find(product_id)
  end
end
