class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_one_attached :picture , dependent: :destroy
  
  acts_as_list scope: :imageable
end
