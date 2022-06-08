class Source < ApplicationRecord
  #validates :title, presence: true
  #validates :publication_date, presence: true
  #validates :edition_reference, presence: true
  #validates :web_link, presence: true
  #validates :category, presence: true
  #validates :origine, presence: true
  #validates :note, presence: true

  has_many :citations, dependent: :destroy

  has_many :person_sources, dependent: :destroy
  has_many :people, -> { distinct }, through: :person_sources
  accepts_nested_attributes_for :people

  has_many :plant_sources, dependent: :destroy
  has_many :plants, -> { distinct }, through: :plant_sources
  accepts_nested_attributes_for :plants

  has_many :area_sources, dependent: :destroy
  has_many :areas, -> { distinct }, through: :area_sources
  accepts_nested_attributes_for :areas

  has_many :name_sources, dependent: :destroy
  has_many :names, -> { distinct }, through: :name_sources
  accepts_nested_attributes_for :names


end
