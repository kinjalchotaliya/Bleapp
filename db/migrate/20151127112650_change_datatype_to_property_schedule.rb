class ChangeDatatypeToPropertySchedule < ActiveRecord::Migration
  def change
  	change_column :property_schedules, :date,  :string
  end
end
