class AddDescriptionSpecie < ActiveRecord::Migration[7.0]
    def change
      add_column :species, :description, :string
  end
end
