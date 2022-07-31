class CreateUtilizationCitations < ActiveRecord::Migration[7.0]
  def change
    create_table :utilization_citations do |t|
      t.references :citation, null: false, foreign_key: true
      #t.references :pratique, null: false, foreign_key: true

      t.timestamps
    end
  end
end
