class AddDefaultToProperty < ActiveRecord::Migration
  def change
  	change_column :properties, :lat, :float,:default => 0.00000
    change_column :properties, :lon, :float,:default => 0.00000
  end
end
