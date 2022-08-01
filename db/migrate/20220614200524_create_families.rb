class CreateFamilies < ActiveRecord::Migration[7.0]
  def change
    create_table :families do |t|
      t.string :name
      t.timestamps
    end

    add_reference :plants, :family, null: true, foreign_key: true
    remove_column :plants, :family, :string
  end
end
