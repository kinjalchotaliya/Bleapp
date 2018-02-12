class CreateAgentInfos < ActiveRecord::Migration
  def change
    create_table :agent_infos do |t|
      t.string :office_phone
      t.string :asso_agency
      t.string :license_no
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :agent_infos, :users
  end
end
