class AddChangesFromImage < ActiveRecord::Migration
  def change
  	remove_column :images, :bleeapp_id
  end
end
