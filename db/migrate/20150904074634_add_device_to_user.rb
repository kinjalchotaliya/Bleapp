class AddDeviceToUser < ActiveRecord::Migration
  def change
    add_column :users, :device_type, :integer
    add_column :users, :device_token, :string
  end
end
