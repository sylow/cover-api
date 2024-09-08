class Resume < ApplicationRecord
  belongs_to :user

  # Validations
  # validates :title, presence: true, length: { maximum: 100 }
  # validates :resume, presence: true, length: { minimum: 500 }
end