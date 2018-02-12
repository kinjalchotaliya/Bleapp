class CreateBleImages < ActiveRecord::Migration
  def change
    create_table :ble_images do |t|
      t.references :bleeapp, index: true

      t.timestamps null: false
    end
    add_attachment  :ble_images, :image
    add_foreign_key :ble_images, :bleeapps
  end
end
