class CreateCartProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :cart_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :cart, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0
      t.integer :total_cents, default: 0, null: false
      t.string :currency, default: 'eur'

      t.timestamps
    end
  end
end
