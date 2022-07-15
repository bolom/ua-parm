class AddIntraSpeciesForm < ActiveRecord::Migration[7.0]
  def change
    add_column :forms, :infraspecies, :string
  end
end
