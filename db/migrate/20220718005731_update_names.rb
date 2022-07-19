class UpdateNames < ActiveRecord::Migration[7.0]
  def change
    remove_index :names,  column: :plant_id
    remove_column :names, :plant_id
    remove_column :names, :category
  end
end
