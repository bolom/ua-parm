class AddFamilyGenusPlants < ActiveRecord::Migration[7.0]
  def change
    add_reference :plants, :genus, index: true, type: :integer
    add_reference :plants, :family, index: true, type: :integer
  end
end
