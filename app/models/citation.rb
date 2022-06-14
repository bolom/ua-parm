class Citation < ApplicationRecord
  validates:pratique, presence: true
  validates:text, presence: true
  validates:pages, presence: true
  validates:note, presence: true

  belongs_to :source
  belongs_to :name

  has_many :utilization_citations, dependent: :destroy
  has_many :utilizations, -> { distinct }, through: :utilization_citations

  accepts_nested_attributes_for :utilizations, reject_if: :all_blank, allow_destroy: true

  has_many :name_citations, dependent: :destroy
  has_many :names, -> { distinct }, through: :name_citations

  accepts_nested_attributes_for :names, reject_if: :all_blank, allow_destroy: true
end
