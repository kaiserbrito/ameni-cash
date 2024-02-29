class CreatePromotions < ActiveRecord::Migration[7.2]
  def change
    create_table :promotions do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :discount, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
