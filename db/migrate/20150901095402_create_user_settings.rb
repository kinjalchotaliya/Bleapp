class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.boolean :contact_by_email
      t.boolean :contact_by_sms
      t.boolean :work_with_agent
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :user_settings, :users
  end
end
