class CreateCarts < ActiveRecord::Migration[7.2]
  def change
    create_table :carts do |t|
      t.integer :total_cents, default: 0, null: false
      t.string :currency, default: 'eur', null: false

      t.timestamps
    end
  end
end
