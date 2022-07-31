require "down"

class Species < ApplicationRecord

  belongs_to :genus, optional: true

  has_many_attached :images , dependent: :destroy
  has_many :synonyms , as: :synonymable , dependent: :destroy

  has_many :descriptions , as: :descriptionable, class_name: "Description"
  has_one :distribution , as: :distributionable, class_name: "Distribution"
  has_one :plant

  def ksp
    ksp = descriptions.find_by(key: "KSP")
    if ksp
      ksp.description
    end
  end

  def description
      ksp["general"][0]["description"] if ksp
  end

  def synonymable
    Synonym.find_by(synonymable_copy_id: self.id).synonymable
  end


end
