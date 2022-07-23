class RemoveFamilyPlants < ActiveRecord::Migration[7.0]
  def change
    remove_column :plants, :family_id
    remove_column :plants, :scientific

  end
end
