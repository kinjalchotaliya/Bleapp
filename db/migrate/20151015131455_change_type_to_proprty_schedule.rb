class ChangeTypeToProprtySchedule < ActiveRecord::Migration
  def change
  	change_column :property_schedules, :from,  :string
  	change_column :property_schedules, :to,  :string
  end
end
