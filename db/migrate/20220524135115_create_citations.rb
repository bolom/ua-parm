class CreateCitations < ActiveRecord::Migration[7.0]
  def change
    create_table :citations do |t|
      t.string :pratique
      t.string :text
      t.string :pages
      t.string :note
      t.belongs_to :source


      t.timestamps
    end
  end
end
