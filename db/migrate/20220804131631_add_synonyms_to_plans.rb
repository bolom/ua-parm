class AddSynonymsToPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :plants, :synonym_ids, :text, array: true, default: []
  end
end
