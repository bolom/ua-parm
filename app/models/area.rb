class Area < ApplicationRecord
  validates :name, presence: true
  has_many :area_sources, dependent: :destroy

end
