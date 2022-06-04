class Source < ApplicationRecord
  #validates :title, presence: true
  #validates :publication_date, presence: true
  #validates :edition_reference, presence: true
  #validates :web_link, presence: true
  #validates :category, presence: true
  #validates :origine, presence: true
  #validates :note, presence: true

  has_many :person_sources
  has_many :people, through: :person_sources

end
