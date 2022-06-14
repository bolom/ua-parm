class Plant < ApplicationRecord
  include PgSearch::Model

  #enum :pharmacopoeia, [:tramil, :aucune, :test2]
  #enum :family, [:test5, :test4, :test3]

  #validation
  validates :scientific, presence: true , uniqueness: true

  validates :pharmacopoeia, presence: true
  validates :family, presence: true

  has_many :names , dependent: :destroy
  has_many :citations, -> { distinct }, through: :names
  has_many :sources, -> { distinct }, through: :citations

  #accepts_nested_attributes_for :sources


  pg_search_scope :search_by_scientific,
    against: :scientific,
    using: { tsearch: { prefix: true } }

  scope :ordered, -> { order(id: :desc) }
  scope :by_family, ->(value) { send(value)  }
  scope :by_pharmacopoeia, ->(value) { where("pharmacopoeia = ? ", value) if value.present? }
  scope :by_family, ->(value) { where("family = ? ", value) if value.present? }
  scope :search, ->(value) { search_by_scientific(value) if value.present? }
end
