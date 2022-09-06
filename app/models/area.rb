class Area < ApplicationRecord
  validates :name, presence: true
  validates_uniqueness_of :name , :uniqueness => {:case_sensitive => false}
  has_many :area_sources, dependent: :destroy
  has_many :sources, -> { distinct }, through: :area_sources
end
