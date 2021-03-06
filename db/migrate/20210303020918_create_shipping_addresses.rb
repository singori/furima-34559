class CreateShippingAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :shipping_addresses do |t|
      t.string :postal_code, null: false
      t.integer :prefecture_id, null: false
      t.string :municipalities, null: false
      t.string :address, null: false
      t.string :builing_name
      t.string :phone_number, null: false
      t.references :buyer, foreign_key: true
      t.timestamps
    end
  end
end
