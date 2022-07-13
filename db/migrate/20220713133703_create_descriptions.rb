class CreateDescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :descriptions do |t|
      t.string   :key
      t.string   :name
      t.boolean  :from_synonym
      t.jsonb   :descriptions, null: false, default: '{}'
      t.bigint  :descriptionable_id
      t.string  :descriptionable_type
      t.timestamps
    end

    add_index  :descriptions, :descriptions, using: :gin
  end
end
