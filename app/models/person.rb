class Person < ApplicationRecord
#  validates:last_name, presence: true
#  validates:first_name, presence: true
  #validates:category, presence: true

  has_many :person_sources , dependent: :destroy
  has_many :sources, through: :person_sources

  def full_name
    "#{first_name} #{last_name}"
  end
end
