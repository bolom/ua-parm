class DropForms < ActiveRecord::Migration[7.0]
  def change
    drop_table :forms
  end
end
