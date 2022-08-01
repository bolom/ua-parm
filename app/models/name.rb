class Name < ApplicationRecord
   has_many :citations
   has_many :sources, -> { distinct }, through: :citations
   has_many :name_plants, dependent: :destroy
   has_many :plants, -> { distinct }, through: :name_plants

   validates:label, presence: true

end
