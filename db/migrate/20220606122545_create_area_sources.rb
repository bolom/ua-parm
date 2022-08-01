class CreateAreaSources < ActiveRecord::Migration[7.0]
  def change
    create_table :area_sources do |t|
      t.references :source, null: false, foreign_key: true
      t.references :area, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
