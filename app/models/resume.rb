# == Schema Information
#
# Table name: resumes
#
#  content :text
#  title   :string
#  user_id :bigint           not null, indexed
#
# Indexes
#
#  index_resumes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Resume < ApplicationRecord
  belongs_to :user
  has_many :covers
  has_many :enhanced_resumes
  has_many :chat_logs, as: :loggable
  has_one :enhanced_resume, -> { where(kind: 'enhance') }, class_name: 'EnhancedResume'

  # Validations
  validates :title, presence: true, length: { minimum: 5 }
  validates :content, presence: true, length: { minimum: 500, maximum: 7000 }
end
