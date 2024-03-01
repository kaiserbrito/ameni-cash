# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateTotalPriceService do
  let(:calculate) { described_class.new(products_cart_id:).call }

  context 'when products_cart does not exist' do
    let(:products_cart_id) { 0 }

    it 'returns false', :aggregate_failures do
      expect(calculate.success).to be_falsey
      expect(calculate.message).to eq('Failed to calculate total price: Couldn\'t find ProductsCart with \'id\'=0')
    end
  end

  context 'when promotion does not exist' do
    let(:green_tea) { create(:product, name: 'Green Tea', code: 'GR1', price_cents: 311) }
    let(:products_cart) { create(:products_cart, product: green_tea, quantity: 2, total_cents: 0) }
    let(:products_cart_id) { products_cart.id }

    it 'returns the total price' do
      expect { calculate }.to change { products_cart.reload.total_cents }.from(0).to(622)
    end
  end

  context 'when promotion is not applicable' do
    let(:green_tea) { create(:product, name: 'Green Tea', code: 'GR1', price_cents: 311) }

    let!(:promotion) do
      create(
        :promotion,
        name: 'Buy one get one free',
        discount: 100,
        quantity: 2,
        product: green_tea
      )
    end
    let(:products_cart) { create(:products_cart, product: green_tea, quantity: 1, total_cents: 0) }
    let(:products_cart_id) { products_cart.id }

    it 'returns the total price' do
      expect { calculate }.to change { products_cart.reload.total_cents }.from(0).to(311)
    end
  end

  context 'when promotion is applicable' do
    let(:green_tea) { create(:product, name: 'Green Tea', code: 'GR1', price_cents: 311) }

    let!(:promotion) do
      create(
        :promotion,
        name: 'Buy one get one free',
        discount: 100,
        quantity: 2,
        product: green_tea
      )
    end
    let(:products_cart) { create(:products_cart, product: green_tea, quantity: 2, total_cents: 0) }
    let(:products_cart_id) { products_cart.id }

    it 'returns the total price' do
      expect { calculate }.to change { products_cart.reload.total_cents }.from(0).to(311)
    end
  end
end
