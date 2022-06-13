class Citation < ApplicationRecord
  validates:pratique, presence: true
  validates:text, presence: true
  validates:pages, presence: true
  validates:note, presence: true

  belongs_to :source
  belongs_to :name
end
