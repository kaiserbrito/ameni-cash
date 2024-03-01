class CreatePromotions < ActiveRecord::Migration[7.2]
  def change
    create_enum :discount_type, %w[bogo fixed percentage]

    create_table :promotions do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :discount, null: false
      t.integer :quantity, null: false
      t.enum :discount_type, enum_type: :discount_type, null: false, default: 'bogo'

      t.timestamps
    end
  end
end
