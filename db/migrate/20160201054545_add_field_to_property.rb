class AddFieldToProperty < ActiveRecord::Migration
  def change
  	add_column :properties, :is_active, :boolean, :default => true
  end
end
