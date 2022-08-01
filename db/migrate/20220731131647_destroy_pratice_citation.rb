class DestroyPraticeCitation < ActiveRecord::Migration[7.0]
  def change
    remove_column :citations, :pratique
  end
end
