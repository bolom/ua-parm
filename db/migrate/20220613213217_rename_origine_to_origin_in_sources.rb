class RenameOrigineToOriginInSources < ActiveRecord::Migration[7.0]
  def change
     rename_column :sources, :origine, :origin
  end
end
