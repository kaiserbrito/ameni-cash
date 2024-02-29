# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'validations' do
    it 'checks for presence of total_cents and currency', :aggregate_failures do
      is_expected.to validate_presence_of(:total_cents)
      is_expected.to validate_presence_of(:currency)

      is_expected.to validate_numericality_of(:total_cents).is_greater_than_or_equal_to(0)
    end
  end

  describe '#total_price' do
    let(:cart) { create(:cart, total_cents: 1000) }

    it 'returns the price in the correct format' do
      expect(cart.total_price.format).to eq('€10.00')
    end
  end
end
