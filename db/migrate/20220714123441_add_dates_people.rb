class AddDatesPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :date_dc, :string
    add_column :people, :date_birth, :string

  end
end
