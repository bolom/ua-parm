class AddScientificToPlant < ActiveRecord::Migration[7.0]
  def change
    add_column :plants, :scientific, :string
  end
end
