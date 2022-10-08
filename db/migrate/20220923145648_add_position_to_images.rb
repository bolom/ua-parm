class AddPositionToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :position, :integer, default: 0
    remove_column :images, :order, :integer
  end
end
