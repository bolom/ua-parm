class Name < ApplicationRecord
#   has_many :sources, -> { distinct }, through: :citations

   has_many :name_plants, dependent: :destroy
   has_many :plants, -> { distinct }, through: :name_plants

   has_many :name_citations, dependent: :destroy
   has_many :citations, -> { distinct }, through: :name_citations

   validates:label, uniqueness: true, presence: true

  def self.names_plants
    names = []
    Name.joins(:name_plants).group(:name_id).pluck('array_agg(name_plants.plant_id)','array_agg("label")').each do |n|
      names << [n[1][0],n[0].join(",")]
    end
    names
  end
end
