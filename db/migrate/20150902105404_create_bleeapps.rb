class CreateBleeapps < ActiveRecord::Migration
  def change
    create_table :bleeapps do |t|
      t.string :title
      t.string :tags
      t.text :description
      t.references :property, index: true
      t.references :beacon, index: true
      t.timestamps null: false
    end
    add_foreign_key :bleeapps, :properties
  end
end
