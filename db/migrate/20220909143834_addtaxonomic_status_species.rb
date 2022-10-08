class AddtaxonomicStatusSpecies < ActiveRecord::Migration[7.0]
  def change
    add_column :species, :taxonomic_status, :string
    add_column :species, :nomenclatural_code, :string
    add_column :species, :lifeform, :string
    add_column :species, :climate, :string
    add_column :species, :hybrid, :boolean
  end
end
