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

    context 'when cart does not exist' do
      let(:cart_id) { 0 }

      it 'returns false', :aggregate_failures do
        expect(add_products.success).to be_falsey
        expect(add_products.message).to eq('Failed to add product to cart: Validation failed: Cart must exist')
      end
    end

    context 'when product does not exist' do
      let(:product_id) { 0 }

      it 'returns false', :aggregate_failures do
        expect(add_products.success).to be_falsey
        expect(add_products.message).to eq('Failed to add product to cart: Validation failed: Product must exist')
      end
    end

    context 'when fails to calculate total price' do
      before do
        allow_any_instance_of(CalculateTotalPriceService).to receive(:call).and_raise(CalculateTotalPriceService::Error)
      end

      it 'returns false', :aggregate_failures do
        expect(add_products.success).to be_falsey
        expect(add_products.message).to eq('Failed to update total price: CalculateTotalPriceService::Error')
      end
    end

    it 'adds products to the cart and updates total_cents', :aggregate_failures do
      expect { add_products }.to change(cart.products, :count).by(1)
      expect(add_products.success).to be_truthy
      expect(add_products.message).to eq('Product added to cart successfully.')
      expect(cart.reload.total_price.format).to eq('€1.00')
    end

    context 'when product is already in the cart' do
      before { create(:cart_product, cart:, product:, quantity: 1) }

      it 'updates the quantity' do
        expect { add_products }.to change { cart.cart_products.find_by(product:).quantity }.by(1)
        expect(add_products.success).to be_truthy
        expect(add_products.message).to eq('Product added to cart successfully.')
        expect(cart.reload.total_price.format).to eq('€2.00')
      end
    end
  end
end
