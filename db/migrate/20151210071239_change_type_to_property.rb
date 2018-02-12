class ChangeTypeToProperty < ActiveRecord::Migration
  def change
  	change_column :properties, :zip,  :string
  end
end
