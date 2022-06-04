class CreatePersonSources < ActiveRecord::Migration[7.0]
  def change
    create_table :person_sources do |t|
      #t.belongs_to :person
      #t.belongs_to :source
      t.references :person, null: false, foreign_key: true
      t.references :source, null: false, foreign_key: true

      t.timestamps
    end

    #add_foreign_key :people_sources, :people
    #add_index :people_sources, :person_id
    #add_index :people_sources, :source_id

  end
end
