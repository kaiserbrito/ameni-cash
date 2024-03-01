# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartProduct, type: :model do
  describe 'validations' do
    it 'checks for presence of currency, quantity', :aggregate_failures do
      is_expected.to validate_presence_of(:currency)
      is_expected.to validate_presence_of(:quantity)

      is_expected.to validate_numericality_of(:quantity).is_greater_than(0)
      is_expected.to validate_numericality_of(:total_cents).is_greater_than_or_equal_to(0)
    end
  end

  describe 'associations' do
    it 'belongs to product and cart' do
      is_expected.to belong_to(:product)
      is_expected.to belong_to(:cart)
    end
  end
end
