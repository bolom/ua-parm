class CreateNameCitations < ActiveRecord::Migration[7.0]
  def change
    create_table :name_citations do |t|
      t.references :citation, null: false, foreign_key: true
      t.references :name, null: false, foreign_key: true

      t.timestamps
    end
  end
end
