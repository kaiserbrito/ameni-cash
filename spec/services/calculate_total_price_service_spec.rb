# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateTotalPriceService do
  let(:calculate) { described_class.new(cart_product_id:).call }

  context 'when cart_product does not exist' do
    let(:cart_product_id) { 0 }

    it 'raises an error', :aggregate_failures do
      expect { calculate }.to raise_error(
        CalculateTotalPriceService::Error,
        'Failed to calculate total price: Couldn\'t find CartProduct with \'id\'=0'
      )
    end
  end

  context 'when promotion does not exist' do
    let(:green_tea) { create(:product, name: 'Green Tea', code: 'GR1', price_cents: 311) }
    let(:cart_product) { create(:cart_product, product: green_tea, quantity: 2, total_cents: 0) }
    let(:cart_product_id) { cart_product.id }

    it 'returns the total price' do
      expect { calculate }.to change { cart_product.reload.total_cents }.from(0).to(622)
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
    let(:cart_product) { create(:cart_product, product: green_tea, quantity: 1, total_cents: 0) }
    let(:cart_product_id) { cart_product.id }

    it 'returns the total price' do
      expect { calculate }.to change { cart_product.reload.total_cents }.from(0).to(311)
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
    let(:cart_product) { create(:cart_product, product: green_tea, quantity: 2, total_cents: 0) }
    let(:cart_product_id) { cart_product.id }

    it 'returns the total price' do
      expect { calculate }.to change { cart_product.reload.total_cents }.from(0).to(311)
    end
  end
end
