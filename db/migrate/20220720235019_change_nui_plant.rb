class ChangeNuiPlant < ActiveRecord::Migration[7.0]
  def change
    change_column :plants, :nui_plant, :string
  end
end
