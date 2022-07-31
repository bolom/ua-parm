class AddPageCitation < ActiveRecord::Migration[7.0]
  def change
    add_column :citations, :page, :string
  end
end
