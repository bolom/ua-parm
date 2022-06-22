class Name < ApplicationRecord
   belongs_to :plant
   has_many :citations
   has_many :sources, -> { distinct }, through: :citations


   validates:label, presence: true
   #validates:category, presence: true

  # validates :category, inclusion: { in: %w(synonym common),message: "%{value} is not a valid category" }
   validates_uniqueness_of :plant_id, scope: :category, conditions: -> { where(category: :synonym) }

  # scope :synonym, -> { where(category: "synonym").order(id: :desc) }
   scope :commons, -> { where(category: "common").order(id: :desc)}

#   has_many :name_citations, dependent: :destroy
#   has_many :citations, -> { distinct }, through: :name_citations

  def full_name
    "#{label} (#{plant.scientific})"
  end
end
