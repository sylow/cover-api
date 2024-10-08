class CreatePasswordResetTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :password_reset_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token, null: false, unique: true
      t.datetime :expires_at, null: false
      t.timestamps
    end

    add_index :password_reset_tokens, :token, unique: true
  end
end
