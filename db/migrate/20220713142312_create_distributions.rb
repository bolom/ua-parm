class CreateDistributions < ActiveRecord::Migration[7.0]
  def change
    create_table :distributions do |t|
      t.jsonb   :natives, null: false, default: '{}'
      t.jsonb   :introduced, null: false, default: '{}'
      t.jsonb   :doubtful, null: false, default: '{}'
      t.bigint  :distributionable_id
      t.string  :distributionable_type
      t.timestamps
    end
  end
end
