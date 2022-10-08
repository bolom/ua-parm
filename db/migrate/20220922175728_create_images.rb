class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
       t.references :imageable, polymorphic: true
       t.timestamps
       t.integer "order", default: 0
    end
  end
end
