class AddPlantSynonymPlants < ActiveRecord::Migration[7.0]
  def change
    add_column :plants, :synonym_names, :text, array: true, default: []
    add_index :plants, :synonym_names, using: 'gin'
  end
end
