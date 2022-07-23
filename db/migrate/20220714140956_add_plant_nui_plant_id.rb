class AddPlantNuiPlantId < ActiveRecord::Migration[7.0]
  def change
    add_column :plants, :nui_plant, :int
    add_column :plants, :species_id, :int
  end
end
