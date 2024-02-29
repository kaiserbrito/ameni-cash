# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { create(:product) }

  describe 'validations' do
    it 'checks the presence of name, code, price_cents, and currency fields', :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:code)
      is_expected.to validate_presence_of(:price_cents)
      is_expected.to validate_presence_of(:currency)

      is_expected.to validate_uniqueness_of(:code)
      is_expected.to validate_numericality_of(:price_cents).is_greater_than(0)
    end
  end

  describe 'enums' do
    it 'checks the currency enum' do
      is_expected.to define_enum_for(:currency)
        .with_values(eur: 'eur', gbp: 'gbp', usd: 'usd')
        .backed_by_column_of_type(:enum)
    end
  end
end
