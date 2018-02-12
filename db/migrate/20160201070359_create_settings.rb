class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :mile_for_filter
      t.integer :mile_for_list

      t.timestamps null: false
    end
  end
end
