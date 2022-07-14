class PlantSource < ApplicationRecord
  belongs_to :source
  belongs_to :plant
end
