class CreateAuthenticationTokens < ActiveRecord::Migration
  def change
    create_table :authentication_tokens do |t|
      t.string :auth_token
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :authentication_tokens, :users
  end
end
