class CreatePlants < ActiveRecord::Migration[7.0]
  def change
    create_table :plants do |t|
      t.string :family
      t.string :pharmacopoeia

      t.timestamps
    end
  end
end
