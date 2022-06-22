class CreateVarieties < ActiveRecord::Migration[7.0]
  def change
    create_table :varieties do |t|
      t.belongs_to :species
      t.string :source
      t.integer :name_published_in_year
      t.string :taxon_remarks
      t.string :nomenclatural_status

      t.string :locations, array: true
      t.string :authors, array: true

      t.boolean :synonym
      t.boolean :plantae
      t.boolean :fungi
      t.string  :fq_id
      t.string  :name
      t.string  :reference

      t.timestamps
    end
  end
end



   -
