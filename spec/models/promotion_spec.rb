# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Promotion, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:product) }
  end

  describe 'validations' do
    it 'checks for presence of name, discount and quantity', :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:discount)
      is_expected.to validate_presence_of(:quantity)

      is_expected.to validate_numericality_of(:discount).is_greater_than(0)
      is_expected.to validate_numericality_of(:quantity).is_greater_than(1)
    end
  end

  describe 'enums' do
    it do
      is_expected.to define_enum_for(:discount_type)
        .with_values(bogo: 'bogo', fixed: 'fixed', percentage: 'percentage')
        .backed_by_column_of_type(:enum)
    end
  end

  describe '#applicable?' do
    let(:promotion) { create(:promotion, discount: 100, quantity: 2) }

    it 'returns true when quantity is greater than the promotion quantity' do
      expect(promotion.applicable?(3)).to be_truthy
    end

    it 'returns true when quantity is equal to the promotion quantity' do
      expect(promotion.applicable?(2)).to be_truthy
    end

    it 'returns false when quantity is less than the promotion quantity' do
      expect(promotion.applicable?(1)).to be_falsey
    end
  end
end
