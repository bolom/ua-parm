class CreateNamePlants < ActiveRecord::Migration[7.0]
  def change
    create_table :name_plants do |t|
      t.belongs_to :plant
      t.belongs_to :name
      t.timestamps
    end
  end
end
