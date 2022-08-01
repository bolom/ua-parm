class RemovePagesCitations < ActiveRecord::Migration[7.0]
  def change
    remove_column :citations, :pages
  end
end
