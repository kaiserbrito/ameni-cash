# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/index', type: :feature do
  let!(:green_tea) { create(:product, name: 'Green Tea', code: 'GR1', price_cents: 311) }
  let!(:strawberries) { create(:product, name: 'Strawberries', code: 'SR1', price_cents: 500) }
  let!(:coffee) { create(:product, name: 'Coffee', code: 'CF1', price_cents: 1123) }

  let!(:promotion1) do
    create(
      :promotion,
      name: 'Buy one get one free',
      discount: 100,
      quantity: 2,
      product: green_tea
    )
  end
  let!(:promotion2) do
    create(
      :promotion,
      name: 'Buy 3 or more and get 10% off each strawberry',
      discount: 50,
      quantity: 3,
      product: strawberries
    )
  end
  let!(:promotion3) do
    create(
      :promotion,
      name: 'Coffee addiction',
      discount: 33,
      quantity: 3,
      product: coffee
    )
  end

  context 'when cart is empty' do
    it 'renders a list of products with their promotions', :aggregate_failures do
      visit products_path

      expect(page).to have_content('Products')
      expect(page).to have_content('Green Tea')
      expect(page).to have_content('Buy one get one free')
      expect(page).to have_content('Strawberries')
      expect(page).to have_content('Buy 3 or more and get 10% off each strawberry')
      expect(page).to have_content('Coffee')
      expect(page).to have_content('Coffee addiction')

      expect(page).to have_content('Cart')
      expect(page).to have_content('Your cart is empty.')
    end
  end

  context 'when add products to the cart' do
    it 'updates cart total price', :aggregate_failures do
      visit products_path

      click_button('Add to Cart', match: :first)
      expect(page).to have_content('Cart')
      expect(page).to have_content('Green Tea 1')
      expect(page).to have_content('Total: €3.11')

      click_button('Add to Cart', match: :first)
      expect(page).to have_content('Green Tea 2')
      expect(page).to have_content('Total: €3.11')
    end
  end
end
