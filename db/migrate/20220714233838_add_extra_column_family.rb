class AddExtraColumnFamily < ActiveRecord::Migration[7.0]
  def change
    rename_column :families, :plantea, :plantae
  end
end
