class Family < ApplicationRecord
  has_many :plants
  has_many :descriptionables , as: :descriptionable

  scope :with_plants, -> { joins(:plants).uniq }
  scope :ordered, -> { order(name: :asc) }

end
