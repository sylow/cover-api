class CreateChatLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :model
      t.jsonb :messages
      t.jsonb :response
      t.text :summary
      t.boolean :success
      t.string :error

      t.timestamps
    end
  end
end
