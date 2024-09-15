class Resume < ApplicationRecord
  belongs_to :user
  has_many :covers

  # Validations
  validates :title, presence: true, length: { minimum: 5 }
  validates :resume, presence: true, length: { minimum: 500 }
end