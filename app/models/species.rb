require "down"

class Species < ApplicationRecord
  belongs_to :genus, optional: true
  has_many_attached :images  , dependent: :destroy
  has_many :synonyms , as: :synonymable , dependent: :destroy

  has_many :descriptionables , as: :descriptionable, class_name: "Description"
  has_one :distributionable , as: :distributionable, class_name: "Distribution"
end
