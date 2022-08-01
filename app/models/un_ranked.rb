class UnRanked < ApplicationRecord
  has_many :descriptionables , as: :descriptionable
  has_many :synonyms , as: :synonymable
  has_many :descriptionables , as: :descriptionable, class_name: "Description"
  has_one :distributionable , as: :distributionable, class_name: "Distribution"
end
