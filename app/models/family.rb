class Family < ApplicationRecord
  has_many :genera ,class_name: "Genus", dependent: :destroy
  has_many :descriptionables , as: :descriptionable

  has_many :plants
  
  has_many :synonyms , as: :synonymable
  has_many :descriptionables , as: :descriptionable, class_name: "Description"
  has_one :distributionable , as: :distributionable, class_name: "Distribution"
  scope :with_plants, -> { joins(:plants).uniq }
  scope :ordered, -> { order(name: :asc) }

  validates :name, presence: true
end
