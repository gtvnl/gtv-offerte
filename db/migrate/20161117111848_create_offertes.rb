class CreateOffertes < ActiveRecord::Migration[5.0]
  def change
    create_table :offertes do |t|
      t.string :projectnaam
      t.string :projectnummer
      t.string :plaats
      t.integer :status

      t.timestamps
    end
  end
end
