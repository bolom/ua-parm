class PersonSource < ApplicationRecord
  belongs_to :source
  belongs_to :person
end
