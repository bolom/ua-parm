class Area < ApplicationRecord
  validates :name, presence: true
  has_many :area_sources, dependent: :destroy
  has_many :sources, -> { distinct }, through: :area_sources
end
