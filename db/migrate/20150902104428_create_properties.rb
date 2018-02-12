class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :status
      t.text :address
      t.string :city
      t.string :state
      t.integer :zip
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :properties, :users
  end
end
