class CreatePosities < ActiveRecord::Migration[5.0]
  def change
    create_table :posities do |t|
      t.integer :regel
      t.string :fabrikaat
      t.string :systeem
      t.integer :ip
      t.string :verdeler
      t.integer :aantal
      t.float :stuksprijs
      t.references :offerte, foreign_key: true

      t.timestamps
    end
  end
end
