class Family < ApplicationRecord
  has_many :plants

  scope :with_plants, -> { joins(:plants).uniq }
  scope :ordered, -> { order(name: :asc) }

end
