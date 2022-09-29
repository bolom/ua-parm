class AddExtraInfoFamilies < ActiveRecord::Migration[7.0]
  def change
    add_column :families, :taxonomic_status, :string
    add_column :families, :nomenclatural_code, :string
    add_column :families, :lifeform, :string
    add_column :families, :climate, :string
    add_column :families, :hybrid, :boolean
  end
end
