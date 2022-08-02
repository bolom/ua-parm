class CreatePlantSource < ActiveRecord::Migration[7.0]
  def change
    create_table :plant_sources do |t|
      t.references :plant, null: false, foreign_key: true
      t.references :source, null: false, foreign_key: true
      t.timestamps
    end
  end
end
