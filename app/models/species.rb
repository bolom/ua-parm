require "down"

class Species < ApplicationRecord

  belongs_to :genus, optional: true

  has_many_attached :images , dependent: :destroy
  has_many :synonyms , as: :synonymable , dependent: :destroy

  has_many :descriptions , as: :descriptionable, class_name: "Description"
  has_one :distribution , as: :distributionable, class_name: "Distribution"
  has_one :plant

  scope :with_plants, -> { joins(:plant).order(name: :asc).uniq }
  scope :ordered, -> { order(name: :asc) }


  def ksp
    ksp = descriptions.find_by(key: "KSP")
    if ksp
      ksp.descriptions
    end
  end

  def description
      ksp["general"][0]["description"] if ksp
  end

  def natives
    n = []
    unless distribution.nil?
      unless distribution.natives == "{}"
        distribution.natives.each do |native|
            n << native["name"]
        end
      end
    end
    n
  end

  def introduced
    i = []
    unless distribution.nil?
      unless distribution.introduced == "{}"
        distribution.introduced.each do |introduced|
          i << introduced["name"]
        end
      end
    end
    i
  end

  def synonymable
    Synonym.find_by(synonymable_copy_id: self.id).synonymable
  end

  def synonymables
    ids = plant.species.synonyms.pluck(:synonymable_copy_id)
    Species.where(id: ids)
  end

end
