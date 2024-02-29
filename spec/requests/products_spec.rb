# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/products', type: :request do
  let!(:green_tea) { create(:product, name: 'Green Tea', code: 'GR1', price_cents: 311) }
  let!(:strawberries) { create(:product, name: 'Strawberries', code: 'SR1', price_cents: 500) }
  let!(:coffee) { create(:product, name: 'Coffee', code: 'CF1', price_cents: 1123) }

  describe 'GET /index' do
    it 'renders a successful response', :aggregate_failures do
      get products_url

      expect(response).to be_successful
      expect(assigns(:products)).to match_array([green_tea, strawberries, coffee])
    end
  end
end
