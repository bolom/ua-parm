class CreateNameSources < ActiveRecord::Migration[7.0]
  def change
    create_table :name_sources do |t|
      t.references :source, null: false, foreign_key: true
      t.references :name, null: false, foreign_key: true

      t.timestamps
    end
  end
end
