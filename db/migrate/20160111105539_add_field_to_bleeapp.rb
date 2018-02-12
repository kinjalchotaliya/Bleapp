class AddFieldToBleeapp < ActiveRecord::Migration
  def change
    add_column :bleeapps, :minor, :string
    add_column :bleeapps, :major, :string
    add_column :bleeapps, :name, :string
  end
end
