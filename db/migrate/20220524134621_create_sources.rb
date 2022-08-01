class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|
      t.string :title
      t.string :publication_date
      t.string :edition_reference
      t.string :web_link
      t.string :type
      t.string :origine
      t.string :note

      t.timestamps
    end
  end
end
