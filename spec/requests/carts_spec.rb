# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  let(:product) { create(:product, price_cents: 500) }
  let!(:cart) { create(:cart, total_cents: 1000) }
  let!(:cart_product) { create(:cart_product, cart:, product:, total_cents: 1000, quantity: 2) }

  describe 'DELETE /remove_product/:cart_product_id' do
    let(:remove_product) { delete cart_remove_cart_product_path(cart, cart_product) }

    context 'when cart_product quantity is greater than 1' do
      it 'removes a product from the cart' do
        expect { remove_product }.not_to change(CartProduct, :count)
        expect(cart.reload.total_cents).to eq(500)
        expect(cart_product.reload.quantity).to eq(1)
      end
    end

    context 'when cart_product quantity is equal to 1' do
      let!(:cart_product) { create(:cart_product, cart:, product:, total_cents: 1000, quantity: 1) }

      it 'removes a product from the cart' do
        expect { remove_product }.to change(CartProduct, :count).by(-1)
        expect(Cart.count).to eq(0)
      end

      context 'when cart has another product' do
        let!(:another_product) { create(:product, price_cents: 500) }
        let!(:cart) { create(:cart, total_cents: 1500) }
        let!(:another_cart_product) { create(:cart_product, cart:, product: another_product, total_cents: 500, quantity: 1) }

        it 'removes a product from the cart' do
          expect { remove_product }.to change(cart.reload.cart_products, :count).from(2).to(1)
          expect(cart.reload.total_cents).to eq(500)
        end
      end
    end
  end
end
