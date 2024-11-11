# == Schema Information
#
# Table name: chat_logs
#
#  error         :string
#  loggable_type :string           indexed => [loggable_id]
#  messages      :jsonb
#  model         :string
#  response      :jsonb
#  success       :boolean
#  summary       :text
#  loggable_id   :bigint           indexed => [loggable_type]
#  user_id       :bigint           not null, indexed
#
# Indexes
#
#  index_chat_logs_on_loggable  (loggable_type,loggable_id)
#  index_chat_logs_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class ChatLog < ApplicationRecord
  belongs_to :user
  belongs_to :loggable, polymorphic: true
end
