# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/products', type: :request do
  let!(:green_tea) { create(:product, name: 'Green Tea', code: 'GR1', price_cents: 311) }
  let!(:strawberries) { create(:product, name: 'Strawberries', code: 'SR1', price_cents: 500) }
  let!(:coffee) { create(:product, name: 'Coffee', code: 'CF1', price_cents: 1123) }

  describe 'GET /index' do
    it 'renders a successful response', :aggregate_failures do
      get products_url

      expect(response).to be_successful
      expect(assigns(:products)).to match_array([green_tea, strawberries, coffee])
    end
  end

  describe 'POST /add_to_cart' do
    let(:add_to_cart) { post add_to_cart_product_url(green_tea) }

    context 'with valid parameters' do
      it 'adds the product to the cart', :aggregate_failures do
        expect { add_to_cart }.to change(CartProduct, :count).by(1)

        expect(flash[:notice]).to eq('Product added to cart successfully.')
        expect(response).to redirect_to(products_url)
      end
    end

    context 'with invalid parameters' do
      before do
        allow_any_instance_of(AddProductsToCartService).to receive(:call).and_return(
          AddProductsToCartService::ServiceResponse.new(success: false, message: 'Failed to add product to cart')
        )
      end

      it 'does not add the product to the cart', :aggregate_failures do
        expect { add_to_cart }.not_to change(CartProduct, :count)

        expect(flash[:alert]).to eq('Failed to add product to cart')
        expect(response).to redirect_to(products_url)
      end
    end
  end
end
