class CreateBeacons < ActiveRecord::Migration
  def change
    create_table :beacons do |t|
      t.string :uuid
      t.string :name
  	  t.text :description
  	  t.string :date
  	  t.boolean :is_filter, default: false
  	  t.references :user, index: true
      t.timestamps null: false
    end
  end
end