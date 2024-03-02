# frozen_string_literal: true

# Service responsible for adding products to a cart and updating the total price of the cart.
#
class AddProductsToCartService
  ServiceResponse = Struct.new(:success, :message)

  # Initializes the service with the necessary parameters.
  #
  # @param cart_id [Integer] The ID of the cart to which the product will be added.
  # @param product_id [Integer] The ID of the product to be added to the cart.
  # @param quantity [Integer] The quantity of the product to be added (default is 1).
  #
  def initialize(cart_id:, product_id:, quantity: 1)
    @cart_id = cart_id
    @product_id = product_id
    @quantity = quantity
  end

  # Executes the service operation.
  #
  # @return [ServiceResponse] An object indicating the success of the operation and a message.
  #
  def call
    ActiveRecord::Base.transaction do
      add_product_to_cart
      update_total_price
    end

    ServiceResponse.new(success: true, message: 'Product added to cart successfully.')
  rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
    ServiceResponse.new(success: false, message: "Failed to add product to cart: #{e.message}")
  rescue CalculateTotalPriceService::Error => e
    ServiceResponse.new(success: false, message: "Failed to update total price: #{e.message}")
  end

  private

  attr_reader :cart_id, :quantity, :product_id

  def add_product_to_cart
    product_cart = CartProduct.find_or_initialize_by(cart_id:, product_id:)
    product_cart.quantity += quantity
    product_cart.save!
  end

  def update_total_price
    total_cents = cart_products.map do |cart_product|
      CalculateTotalPriceService.new(cart_product_id: cart_product.id).call
    end.sum

    cart.update!(total_cents:)
  end

  def cart
    @cart ||= Cart.find(cart_id)
  end

  def cart_products
    @cart_products ||= cart.cart_products
  end
end
