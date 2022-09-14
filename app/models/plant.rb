class Plant < ApplicationRecord
  include PgSearch::Model
  belongs_to :species , class_name: "Species", optional: true
  belongs_to :genus , class_name: "Genus", optional: true
  belongs_to :family, optional: true

  enum :pharmacopoeia, [:tramil, :french, :nothing, :ayurveda]

  #validation

  #validates :pharmacopoeia, presence: true
  has_many :citations, dependent: :destroy
  has_many :sources, -> { distinct }, through: :citations

  has_many :plant_sources, dependent: :destroy
  has_many :sources, -> { distinct }, through: :plant_sources

  has_many :name_plants, dependent: :destroy
  has_many :names, -> { distinct }, through: :name_plants

  #accepts_nested_attributes_for :sources

  accepts_nested_attributes_for :names, reject_if: :all_blank, allow_destroy: true


  pg_search_scope :search_by_scientific,
    against: :scientific,
    using: { tsearch: { prefix: true } }

  scope :ordered, -> { joins(:species).order(name: :asc) }
  scope :by_pharmacopoeia, -> (value) { send(value) if value.in?(pharmacopoeia.keys) }
  scope :by_plant, ->(value) { where("plants.species_id = ? ", value) if value.present? }
  scope :by_family, ->(value) { where("plants.family_id = ? ", value) if value.present? }
  scope :by_genus, ->(value) { where("plants.genus_id = ? ", value) if value.present? }
  scope :by_species, ->(value) { where("plants.species_id = ? ", value) if value.present? }
  scope :by_synonym, ->(value) { where("? = ANY (synonym_ids)", value) if value.present? }

  scope :search, ->(value) { search_by_scientific(value) if value.present? }

  def name
    species.name
  end

  def image
    if species.images.empty?
      ""
    else
      species.images.first.variant(resize_to_limit: [200, 200])
    end

  end

  def self.primary_and_synomyms
    [['Principales',Species.with_plants.collect {|a| [a.name, a.id]}] , ['Synonymes',  Plant.select(:name, :"names.id").synonyms.pluck(:name, :id)]]
  end

  def self.synonyms
    ids = Plant.pluck(:id, :synonym_ids).join(",")
    ids = ids.split(",").reject(&:empty?)
    Species.where(id: ids).order(name: :asc)
  end
end
