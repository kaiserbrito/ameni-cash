# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:promotions).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:product) }

    it 'checks the presence of name, code, price_cents, and currency fields', :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:code)
      is_expected.to validate_presence_of(:price_cents)

      is_expected.to validate_uniqueness_of(:code)
    end
  end

  describe 'enums' do
    it 'checks the currency enum' do
      is_expected.to define_enum_for(:currency)
        .with_values(eur: 'eur', gbp: 'gbp', usd: 'usd')
        .backed_by_column_of_type(:enum)
    end
  end

  describe '#price' do
    let!(:product) { create(:product, price_cents: 1000, currency:) }

    context "when the currency is 'eur'" do
      let(:currency) { 'eur' }

      it 'returns the price in the correct format' do
        expect(product.price.format).to eq('€10.00')
      end
    end

    context "when the currency is 'gbp'" do
      let(:currency) { 'gbp' }

      it 'returns the price in the correct format' do
        expect(product.price.format).to eq('£10.00')
      end
    end
  end
end
