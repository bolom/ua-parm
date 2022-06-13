class NameCitation < ApplicationRecord
  belongs_to :citation
  belongs_to :name
  belongs_to :plant
end
