require "down"

class Species < ApplicationRecord
  belongs_to :genus, optional: true
  has_many_attached :images
  has_many :synonyms , as: :synonymable

  has_many :descriptionables , as: :descriptionable, class_name: "Description"
  has_one :distributionable , as: :distributionable, class_name: "Distribution"
end
