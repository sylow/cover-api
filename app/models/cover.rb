# == Schema Information
#
# Table name: covers
#
#  aasm_state      :string
#  cover           :text
#  job_description :text
#  preferences     :jsonb
#  resume_content  :text
#  resume_id       :bigint           not null, indexed
#  user_id         :bigint           not null, indexed
#
# Indexes
#
#  index_covers_on_resume_id  (resume_id)
#  index_covers_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (resume_id => resumes.id)
#  fk_rails_...  (user_id => users.id)
#
class Cover < ApplicationRecord
  include StateMachine
  before_create :set_resume_content

  # Associations
  belongs_to :user
  belongs_to :resume
  has_one :credit_transaction, as: :transactionable
  has_many :chat_logs, as: :loggable

  # Validations
  validates :job_description, presence: true, length: { minimum: 5 }

  def set_resume_content
    self.resume_content = resume.content
  end
end
