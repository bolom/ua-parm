class SubSpecies < ApplicationRecord
  belongs_to :species, class_name: 'Species', optional: true
  has_many :descriptionables , as: :descriptionable
end
