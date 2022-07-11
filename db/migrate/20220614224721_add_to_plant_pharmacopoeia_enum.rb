class AddToPlantPharmacopoeiaEnum < ActiveRecord::Migration[7.0]
  def change
    remove_column :plants, :pharmacopoeia, :string
     add_column :plants, :pharmacopoeia, :integer
  end
end
