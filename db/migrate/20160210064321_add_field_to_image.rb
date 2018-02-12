class AddFieldToImage < ActiveRecord::Migration
  def change
  	add_column :images, :is_starred, :boolean, :default => false
  end
end
