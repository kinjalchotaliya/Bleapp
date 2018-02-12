class CreateFavoriteProperties < ActiveRecord::Migration
  def change
    create_table :favorite_properties do |t|
      t.references :user, index: true
      t.references :property, index: true

      t.timestamps null: false
    end
    add_foreign_key :favorite_properties, :users
    add_foreign_key :favorite_properties, :properties
  end
end
