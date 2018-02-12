class AddChangesToBleeapp < ActiveRecord::Migration
  def up
  	add_column :bleeapps, :ble_id, :integer
  	add_attachment :bleeapps, :image
  end

  def down
  	remove_column :bleeapps, :ble_id, :integer
  	remove_attachment :bleeapps, :image
  end
end
