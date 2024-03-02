# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_cart, only: %i[index add_to_cart]

  def index
    @products = Product.includes(:promotion).all
  end

  def add_to_cart
    service = AddProductsToCartService.new(cart_id: @cart.id, product_id: params[:id])
    response = service.call

    if response.success
      redirect_to products_url, notice: response.message
    else
      redirect_to products_url, alert: response.message
    end
  end

  private

  def set_cart
    @cart = Cart.first_or_create
  end
end
