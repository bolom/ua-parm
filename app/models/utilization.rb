class Utilization < ApplicationRecord
  has_many :citations_utilizations, dependent: :destroy
  has_many :citations, -> { distinct }, through: :citations_utilizations
end
