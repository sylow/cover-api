class RenamePasswordResetTokensToUserTokens < ActiveRecord::Migration[7.0]
  def change
    rename_table :password_reset_tokens, :user_tokens
  end
end
