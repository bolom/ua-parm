class Plant < ApplicationRecord
  include PgSearch::Model
  belongs_to :family

  enum :pharmacopoeia, [:tramil, :french, :nothing, :ayurveda]

  #validation
  validates :scientific, presence: true , uniqueness: true

  #validates :pharmacopoeia, presence: true
  has_many :names , dependent: :destroy
  has_many :citations, -> { distinct }, through: :names
  has_many :sources, -> { distinct }, through: :citations

  #accepts_nested_attributes_for :sources


  pg_search_scope :search_by_scientific,
    against: :scientific,
    using: { tsearch: { prefix: true } }

  scope :ordered, -> { order(id: :desc) }
  scope :by_pharmacopoeia, -> (value) { send(value) if value.in?(pharmacopoeia.keys) }
  scope :by_family, ->(value) { where("family_id = ? ", value) if value.present? }
  scope :search, ->(value) { search_by_scientific(value) if value.present? }
end
