class Genus < ApplicationRecord
  belongs_to :family, optional: true
  has_many :species, dependent: :destroy
  has_many :synonyms , as: :synonymable
  has_many :descriptionables , as: :descriptionable, class_name: "Description"
  has_one :distributionable , as: :distributionable, class_name: "Distribution"

  has_many :plants , dependent: :destroy

  validates :name, presence: true
end
