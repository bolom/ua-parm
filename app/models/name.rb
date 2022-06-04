class Name < ApplicationRecord
   has_many :plant
   validates:label, presence: true
   validates:category, presence: true
end
