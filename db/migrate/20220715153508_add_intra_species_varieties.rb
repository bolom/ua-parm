class AddIntraSpeciesVarieties < ActiveRecord::Migration[7.0]
  def change
    add_column :varieties, :infraspecies, :string
  end
end
