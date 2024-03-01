# frozen_string_literal: true

class AddProductsToCartService
  ServiceResponse = Struct.new(:success, :message)

  def initialize(cart_id:, product_id:, quantity: 1)
    @cart_id = cart_id
    @product_id = product_id
    @quantity = quantity
  end

  def call
    ActiveRecord::Base.transaction do
      add_product_to_cart
    end

    ServiceResponse.new(success: true, message: 'Product added to cart successfully.')
  rescue ActiveRecord::RecordNotFound => e
    ServiceResponse.new(success: false, message: "Failed to add product to cart: #{e.message}")
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
