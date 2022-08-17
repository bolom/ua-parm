class DeleteUnusedTaxon < ActiveRecord::Migration[7.0]
  def change
    drop_table :sub_species
    drop_table :subvarieties
    drop_table :un_rankeds
    drop_table :varieties
  end
end
