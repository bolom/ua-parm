class AddNuiSourceCitation < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :nui_source, :string
  end
end
