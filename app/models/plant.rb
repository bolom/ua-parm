class Plant < ApplicationRecord
  has_many :names , dependent: :destroy
end
