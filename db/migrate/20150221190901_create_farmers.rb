class CreateFarmers < ActiveRecord::Migration
  def change
    create_table :farmers do |t|
      t.string :phone_number
      t.string :first_name
      t.string :last_name
      t.string :national_id_number
      t.string :association
      t.string :country
      t.string :county
      t.string :ward
      t.string :nearest_town
      t.string :crops, :array => true
      t.timestamps
    end
  end
end
