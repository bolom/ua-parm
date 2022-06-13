class Plant < ApplicationRecord
  #validation
  validates :scientific, presence: true , uniqueness: true

  validates :pharmacopoeia, presence: true
  validates :family, presence: true

  has_many :names , dependent: :destroy
  has_many :citations, -> { distinct }, through: :names
  has_many :sources, -> { distinct }, through: :citations

  #accepts_nested_attributes_for :sources

  scope :ordered, -> { order(id: :desc) }

end
