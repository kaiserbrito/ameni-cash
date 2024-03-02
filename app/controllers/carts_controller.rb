# frozen_string_literal: true

class CartsController < ApplicationController
  def remove_product
    service = RemoveProductsFromCartService.new(
      cart_id: params[:cart_id],
      cart_product_id: params[:cart_product_id]
    )
    response = service.call

    if response.success
      redirect_to products_url, notice: response.message
    else
      redirect_to products_url, alert: response.message
    end
  end
end
