class CreateSynonyms < ActiveRecord::Migration[7.0]
  def change
    create_table :synonyms do |t|
      t.uuid :original_id
      t.uuid :copy_id
      t.string :rank
      t.timestamps
    end

    add_index :synonyms, :original_id
    add_index :synonyms, :copy_id
  end
end
