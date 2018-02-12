class CreatePropertyDetails < ActiveRecord::Migration
  def change
    create_table :property_details do |t|
      t.string :property_type
      t.string :style
      t.bigint :price
      t.float :sqft
      t.float :lot_size
      t.string :yeat_built
      t.string :beds
      t.string :baths
      t.string :mls
      t.string :garage
      t.string :heat
      t.string :air
      t.string :water
      t.string :sewer
      t.text :description
      t.references :property, index: true

      t.timestamps null: false
    end
    add_foreign_key :property_details, :properties
  end
end
