# == Schema Information
#
# Table name: enhanced_resumes
#
#  aasm_state  :string
#  content     :text
#  kind        :string           default("enhance")
#  preferences :jsonb
#  resume_id   :bigint           not null, indexed
#
# Indexes
#
#  index_enhanced_resumes_on_resume_id  (resume_id)
#
# Foreign Keys
#
#  fk_rails_...  (resume_id => resumes.id)
#
class EnhancedResume < ApplicationRecord
  include StateMachine

  # Associations
  belongs_to :resume
  has_one :user, through: :resume
  has_one :credit_transaction, as: :transactionable
  has_many :chat_logs, as: :loggable

end
