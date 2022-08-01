class AddMoreColumnsToFamily < ActiveRecord::Migration[7.0]
  def change
    add_column :families, :source, :string
    add_column :families, :name_published_in_year, :string
    add_column :families, :taxon_remarks, :string
    add_column :families, :nomenclatural_status, :string
    add_column :families, :locations, :string, array: true, default: []
    add_column :families, :authors, :string, array: true, default: []

    add_column :families, :synonym, :boolean
    add_column :families, :plantea, :boolean
    add_column :families, :fungi, :boolean
    add_column :families, :fq_id, :string
    add_column :families, :reference, :string

  end
end
