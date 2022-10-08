class Synonym < ApplicationRecord
  belongs_to :synonymable, polymorphic: true
  belongs_to :copy, foreign_key: :synonymable_copy_id, class_name: 'Species'

  #def copy
  #  class_object = Object.const_get(self.synonymable_copy_type)
  #  class_object.find(self.synonymable_copy_id)
  #end
end
