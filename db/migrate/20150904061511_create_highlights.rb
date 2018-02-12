class CreateHighlights < ActiveRecord::Migration
  def change
    create_table :highlights do |t|
      t.string :title
      t.text :note
      t.references :property, index: true

      t.timestamps null: false
    end
    add_foreign_key :highlights, :properties
  end
end
