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
end
