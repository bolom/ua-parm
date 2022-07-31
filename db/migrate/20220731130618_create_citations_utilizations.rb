class CreateCitationsUtilizations < ActiveRecord::Migration[7.0]
  def change
    create_table :citations_utilizations do |t|
      t.references :citation, null: false, foreign_key: true
      t.references :utilization, null: false, foreign_key: true
      t.timestamps
    end
  end
end
