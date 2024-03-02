# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemoveProductsFromCartService do
  describe '#call' do
    let(:remove_products) { described_class.new(cart_id:, cart_product_id:, quantity:).call }

    let(:cart) { create(:cart, total_cents: 1000) }
    let(:cart_id) { cart.id }
    let!(:product) { create(:product, price_cents: 500) }
    let!(:cart_product) { create(:cart_product, cart:, product:, total_cents: 1000, quantity: 2) }
    let(:cart_product_id) { cart_product.id }
    let(:quantity) { 1 }

    context 'when cart_product does not exist' do
      let(:cart_product_id) { 0 }

      it 'returns false', :aggregate_failures do
        expect(remove_products.success).to be_falsey
        expect(remove_products.message).to eq('Failed to remove product from cart: Couldn\'t find CartProduct with \'id\'=0')
      end
    end

    context 'when cart does not exist' do
      let(:cart_id) { 0 }

      it 'returns false', :aggregate_failures do
        expect(remove_products.success).to be_falsey
        expect(remove_products.message).to eq('Failed to remove product from cart: Couldn\'t find Cart with \'id\'=0')
      end
    end

    context 'when quantity is greater than cart_product quantity' do
      let(:quantity) { 3 }

      it 'returns false', :aggregate_failures do
        expect(remove_products.success).to be_falsey
        expect(remove_products.message).to eq('Failed to remove product from cart: Validation failed: Quantity must be less than or equal to 2')
      end
    end

    context 'when quantity is equal to cart_product quantity' do
      let(:quantity) { cart_product.quantity }

      it 'removes the all the products from the cart', :aggregate_failures do
        expect { remove_products }.to change(Cart, :count).to(0)
        expect(remove_products.success).to be_truthy
        expect(remove_products.message).to eq('Products removed from cart successfully.')
      end
    end

    context 'when quantity is less than cart_product quantity' do
      let(:quantity) { cart_product.quantity - 1 }

      it 'removes the products from the cart and updates the quantity', :aggregate_failures do
        expect { remove_products }.to change { cart_product.reload.quantity }.by(-1)
        expect(remove_products.success).to be_truthy
        expect(remove_products.message).to eq('Product removed from cart successfully.')
        expect(cart.reload.total_cents).to eq(500)
      end
    end

    context 'when fails to calculate total price' do
      before do
        allow_any_instance_of(CalculateTotalPriceService).to receive(:call).and_raise(CalculateTotalPriceService::Error)
      end

      it 'returns false', :aggregate_failures do
        expect(remove_products.success).to be_falsey
        expect(remove_products.message).to eq('Failed to update total price: CalculateTotalPriceService::Error')
      end
    end
  end
end
