# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_enum :product_currency, ["eur", "usd", "gbp"]

    create_table :products do |t|
      t.text :name, null: false
      t.string :code, null: false, index: { unique: true }
      t.integer :price_cents, null: false
      t.enum :currency, enum_type: :product_currency, default: "eur", null: false

      t.timestamps
    end
  end
end
