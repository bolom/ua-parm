class Genus < ApplicationRecord
  belongs_to :family, optional: true
  has_many :species, dependent: :destroy
  has_many :synonyms , as: :synonymable
  has_many :descriptions , as: :descriptionable, class_name: "Description"
  has_one :distribution , as: :distributionable, class_name: "Distribution"

  has_many :plants , dependent: :destroy

  scope :with_plants, -> { joins(:plants).uniq }
  validates :name, presence: true
end
