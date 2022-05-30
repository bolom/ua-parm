class Plant < ApplicationRecord
  validates :scientific, presence: true
  has_many :names , dependent: :destroy
end
