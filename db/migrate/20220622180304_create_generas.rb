class CreateGeneras < ActiveRecord::Migration[7.0]
  def change
    create_table :generas do |t|

      t.timestamps
    end
  end
end
