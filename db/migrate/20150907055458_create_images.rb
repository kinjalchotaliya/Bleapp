class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :property, index: true
      t.references :bleeapp, index: true
      t.timestamps null: false
    end
    add_attachment  :images, :image
    add_foreign_key :images, :properties
    add_foreign_key :images, :bleeapps
  end
end
