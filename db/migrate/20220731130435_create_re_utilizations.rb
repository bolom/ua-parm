class CreateReUtilizations < ActiveRecord::Migration[7.0]
  def change
    create_table :utilizations do |t|
      t.string :label
      t.timestamps
    end
  end
end
