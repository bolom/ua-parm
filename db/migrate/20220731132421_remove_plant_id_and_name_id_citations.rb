class RemovePlantIdAndNameIdCitations < ActiveRecord::Migration[7.0]
  def change
  #  remove_column :citations, :plants_id
    remove_column :citations, :name_id
  end
end
