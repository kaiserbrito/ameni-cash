# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/index', type: :view do
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

  before do
    assign(:products, [green_tea, strawberries, coffee])
    assign(:promotions, [green_tea.promotions, strawberries.promotions, coffee.promotions])
  end

  it 'renders a list of products with their promotions', :aggregate_failures do
    render

    expect(rendered).to match(/Products/)
    expect(rendered).to match(/Green Tea/)
    expect(rendered).to match(/Strawberries/)
    expect(rendered).to match(/Coffee/)
    expect(rendered).to match(/Buy one get one free/)
    expect(rendered).to match(/Buy 3 or more and get 10% off each strawberry/)
    expect(rendered).to match(/Coffee addiction/)
  end
end
