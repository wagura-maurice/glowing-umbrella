class CreateEgranaryFloats < ActiveRecord::Migration
  def change
    create_table :egranary_floats do |t|
      t.float :value
      t.integer :year
      t.integer :season
      t.string :txn_type
      t.string :currency
      t.string :entry_method
      t.belongs_to :user, type: :uuid, index: true
      t.timestamps null: false
    end
  end
end
