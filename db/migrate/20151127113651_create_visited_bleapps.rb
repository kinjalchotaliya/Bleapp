class CreateVisitedBleapps < ActiveRecord::Migration
  def change
    create_table :visited_bleapps do |t|
      t.references :user, index: true
      t.references :bleeapp, index: true

      t.timestamps null: false
    end
    add_foreign_key :visited_bleapps, :users
    add_foreign_key :visited_bleapps, :bleeapps
  end
end
