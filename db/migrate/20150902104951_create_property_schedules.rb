class CreatePropertySchedules < ActiveRecord::Migration
  def change
    create_table :property_schedules do |t|
      t.date :date
      t.time :from
      t.time :to
      t.references :property, index: true

      t.timestamps null: false
    end
    add_foreign_key :property_schedules, :properties
  end
end
