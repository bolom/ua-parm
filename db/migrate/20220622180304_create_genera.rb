class CreateGenera < ActiveRecord::Migration[7.0]
  def change
    create_table :genera do |t|
      t.belongs_to :family




      t.timestamps
    end
  end
end
