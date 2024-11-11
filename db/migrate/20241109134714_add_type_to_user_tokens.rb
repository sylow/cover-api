class AddTypeToUserTokens < ActiveRecord::Migration[7.0]
  def change
    add_column :user_tokens, :kind, :string, null: false, default: 'password_reset_token'
  end
end
