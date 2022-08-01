class CreateUtilizations < ActiveRecord::Migration[7.0]
  def change
    remove_column :citations, :pratique, :string
    create_table :utilizations do |t|
      t.string :label
      t.timestamps
    end
  end
end
