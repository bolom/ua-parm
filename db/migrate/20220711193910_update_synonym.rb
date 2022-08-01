class UpdateSynonym < ActiveRecord::Migration[7.0]
  def change
    remove_column :synonyms, :original_id, :integer
    remove_column :synonyms, :copy_id, :integer

    add_column :synonyms, :synonymable_id, :bigint
    add_column :synonyms, :synonymable_copy_id, :bigint

    add_column :synonyms, :synonymable_type, :string

    add_index :synonyms, [:synonymable_id, :synonymable_type]
  end
end
