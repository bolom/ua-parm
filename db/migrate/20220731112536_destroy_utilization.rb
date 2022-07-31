class DestroyUtilization < ActiveRecord::Migration[7.0]
  def change
    drop_table :utilizations
    drop_table :utilization_citations
  end
end
