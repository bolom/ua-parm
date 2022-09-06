class Citation < ApplicationRecord
  validates:text, presence: true

  belongs_to :source
  belongs_to :plant, optional: true

  has_many :citations_utilizations, dependent: :destroy
  has_many :utilizations, -> { distinct }, through: :citations_utilizations

  has_many :name_citations, dependent: :destroy
  has_many :names, -> { distinct }, through: :name_citations

  accepts_nested_attributes_for :utilizations, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :names, reject_if: :all_blank, allow_destroy: true


  scope :ordered, -> { order(id: :desc) }
  scope :by_source, ->(value) { where("source_id = ? ", value) if value.present? }
  scope :by_utilization, ->(value) { joins(:citations_utilizations).where("utilization_id = ? ", value) if value.present? }
  scope :by_name, ->(value) { joins(:name_citations).where("name_id = ? ", value) if value.present? }
  scope :by_plant, ->(value) { where("plant_id = ? ", value) if value.present? }

  def self.plants
     Plant.select(:name).distinct.joins(:citations,:species).order('species.name': :asc).pluck('species.name', 'plants.id')
  end

  def self.names
    Name.select(:label).distinct.joins(:citations,:name_citations).order('names.label': :asc).pluck('names.label', 'names.id')
 end

 def self.sources
   Source.select(:title).distinct.joins(:citations).order('sources.title': :asc).pluck('sources.title', 'sources.id')
 end

 def self.utilizations
   Utilization.select(:label).distinct.joins(:citations_utilizations).order('utilizations.label': :asc).pluck('utilizations.label', 'utilizations.id')
 end
end
