class CreateSynonyms < ActiveRecord::Migration[7.0]
  def change
    create_table :synonyms do |t|
      t.uuid :original_id, null false
      t.uuid :copy_id, null false

      t.string :rank
      
      t.timestamps
    end
  end
end
