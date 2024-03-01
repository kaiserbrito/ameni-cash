# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddProductsToCartService do
  describe '#call' do
    let(:add_products) { described_class.new(cart_id:, product_id:, quantity:).call }

    let(:cart) { create(:cart, total_cents: 0) }
    let(:cart_id) { cart.id }
    let(:product) { create(:product, price_cents: 100) }
    let(:product_id) { product.id }
    let(:quantity) { 1 }

    context 'when product does not exist' do
      let(:product_id) { 0 }

      it 'returns false' do
        expect(add_products).to be_falsey
      end
    end

    it 'adds products to the cart' do
      expect { add_products }.to change(cart.products, :count).by(1)
    end

    context 'when product is already in the cart' do
      before { create(:products_cart, cart:, product:, quantity: 1) }

      it 'updates the quantity' do
        expect { add_products }.to change { cart.products_carts.find_by(product:).quantity }.by(1)
      end
    end
  end
end
