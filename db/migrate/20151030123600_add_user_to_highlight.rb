class AddUserToHighlight < ActiveRecord::Migration
  def change
    add_reference :highlights, :user, index: true
    add_foreign_key :highlights, :users
  end
end
