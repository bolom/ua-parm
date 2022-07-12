class Variety < ApplicationRecord
  belongs_to :species, class_name: 'Species', optional: true
end
