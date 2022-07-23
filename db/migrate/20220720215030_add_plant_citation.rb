class AddPlantCitation < ActiveRecord::Migration[7.0]
  def change
    add_reference :citations, :plant, null: false, foreign_key: true
  end
end 
