class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :rate
      t.boolean :intrested
      t.boolean :contactable
      t.text :comments
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :feedbacks, :users
  end
end
