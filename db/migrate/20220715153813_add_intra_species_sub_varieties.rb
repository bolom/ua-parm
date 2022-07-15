class AddIntraSpeciesSubVarieties < ActiveRecord::Migration[7.0]
  def change
    add_column :subvarieties, :infraspecies, :string
  end
end
