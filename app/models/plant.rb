class Plant < ApplicationRecord
  belongs_to :species , class_name: "Species", optional: true
  delegate :name, to: :species
  delegate :images, to: :species

  belongs_to :genus , class_name: "Genus", optional: true
  delegate   :name, to: :genus, prefix: :genus

  belongs_to :family, optional: true
  delegate   :name, to: :family, prefix: :family

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



  scope :ordered, -> { joins(:species).order(name: :asc) }
  scope :by_pharmacopoeia, -> (value) { send(value) if value.in?(pharmacopoeia.keys) }
  scope :by_plant, ->(value) { where("plants.species_id = ? ", value) if value.present? }
  scope :by_family, ->(value) { where("plants.family_id = ? ", value) if value.present? }
  scope :by_genus, ->(value) { where("plants.genus_id = ? ", value) if value.present? }
  scope :by_species, ->(value) { where("plants.species_id = ? ", value) if value.present? }

  scope :search, ->(value) {
    joins(:species, :name_plants, :names).where("? ILIKE ANY (synonym_names) OR species.name ILIKE ? OR  names.label ILIKE ? ","#{value}", "%#{value}%", "%#{value}%")  if value.present?
  }

  def self.filter(filters)
    plants =  Plant.search(filters[:search])
    .by_pharmacopoeia(filters[:pharmacopoeia])
    .by_family(filters[:family])
    .by_genus(filters[:genus])
    .order("#{filters[:column]} #{filters[:direction]}").ordered.uniq
    plants
  end


  def image
    if species.images.empty?
      ""
    else
      species.images.first.picture.variant(resize_to_limit: [400, 400])
    end

  end

  def synonyms
    Species.where(id: synonym_ids).order(name: :asc).pluck(:taxonomic_status, :name).group_by(&:first).map {|k,v| [k, v.map(&:last)]}
  end

  def self.primary_and_synomyms
    {
       'Accepted' => Species.with_plants.pluck(:name, :id),
       'Synonym' => Plant.synonyms
   }
  end

  def self.synonyms
    synonyms = []
    ids = Plant.pluck(:species_id, :synonym_ids)
    ids.each do |species_id, synonym_ids|
      synonym_names = Species.where(id: synonym_ids).order(name: :asc).pluck(:name)
      synonym_names.each do |synonym_name|
        synonyms << [synonym_name, species_id]
      end
    end
    synonyms
  end
end
