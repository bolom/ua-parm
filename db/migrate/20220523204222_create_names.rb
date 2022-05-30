class CreateNames < ActiveRecord::Migration[7.0]
  def change
    create_table :names do |t|
      t.string :label
      t.string :category
      t.belongs_to :plant


      t.timestamps
    end
  end
end
