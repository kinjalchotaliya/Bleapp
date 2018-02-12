class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :property, index: true

      t.timestamps null: false
    end
    add_attachment :documents, :file
    add_foreign_key :documents, :properties
  end
end
