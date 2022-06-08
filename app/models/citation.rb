class Citation < ApplicationRecord
  validates:pratique, presence: true
  validates:text, presence: true
  validates:pages, presence: true
  validates:note, presence: true

  belongs_to :source
  has_many :name_citations, dependent: :destroy 
  has_many :names, -> { distinct }, through: :name_citations
  accepts_nested_attributes_for :names
end
