class Source < ApplicationRecord
  validates :title, presence: true
  #validates :publication_date, presence: true
  #validates :edition_reference, presence: true
  #validates :web_link, presence: true
  #validates :category, presence: true
  #validates :origine, presence: true
  #validates :note, presence: true
  has_many :citations, dependent: :destroy

  has_many :person_sources, dependent: :destroy
  has_many :people, -> { distinct }, through: :person_sources
  accepts_nested_attributes_for :people, reject_if: :all_blank, allow_destroy: true

  has_many :area_sources, dependent: :destroy
  has_many :areas, -> { distinct }, through: :area_sources
  accepts_nested_attributes_for :areas, reject_if: :all_blank, allow_destroy: true

  has_many :plant_sources, dependent: :destroy
  has_many :plants, -> { distinct }, through: :plant_sources


  scope :ordered, -> { order(id: :desc) }
  scope :by_author, ->(value) { joins(:person_sources).where("person_id = ? ", value) if value.present? }
  scope :by_area, ->(value) { joins(:area_sources).where("area_id = ? ", value) if value.present? }
  scope :by_plant, ->(value) { joins(:plant_sources).where("plant_id = ? ", value) if value.present? }

   def authors_full_name
     authors = []
     self.people.pluck(:first_name,:last_name).each do |person|
       authors << "#{person.first.capitalize} #{person.last.capitalize}"
     end
     authors.join(',')
   end

   def plants_names
     unless plants.empty?
       plants.collect {|a| [a.name]}.join(",")
     end
   end

end
