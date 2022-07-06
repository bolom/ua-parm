class Genus < ApplicationRecord
  belongs_to :family, optional: true

  has_many :species
end
