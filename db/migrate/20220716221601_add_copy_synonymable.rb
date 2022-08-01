class AddCopySynonymable < ActiveRecord::Migration[7.0]
  def change
    add_column :synonyms, :synonymable_copy_type, :string
  end
end
