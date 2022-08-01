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
  scope :by_plant, ->(value) { joins(:citations).where("plant_id = ? ", value) if value.present? }
end
