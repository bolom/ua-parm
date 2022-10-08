class AddExtraInfoGenera < ActiveRecord::Migration[7.0]
  def change
    add_column :genera, :taxonomic_status, :string
    add_column :genera, :nomenclatural_code, :string
    add_column :genera, :lifeform, :string
    add_column :genera, :climate, :string
    add_column :genera, :hybrid, :boolean
  end
end
