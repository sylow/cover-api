class AddLoggableToChatLogs < ActiveRecord::Migration[7.0]
  def change
    add_reference :chat_logs, :loggable, polymorphic: true, index: true
  end
end
