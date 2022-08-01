class AddPlantToCitations < ActiveRecord::Migration[7.0]
  def change
    add_reference :citations, :name, null: true, foreign_key: true
  end
end
