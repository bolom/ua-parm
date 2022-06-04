class RenameTypeToCategoryInSources < ActiveRecord::Migration[7.0]
  def change
    rename_column :sources, :type, :category
  end
end
