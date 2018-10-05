class AddPayments < ActiveRecord::Migration
  def change
    create_table :txns do |t|
      t.float :value
      t.string :account_id
      t.string :completed_at
      t.string :name
      t.string :txn_type
      t.string :phone_number
      t.belongs_to :farmer, index: true
      t.timestamps null: false
    end

    add_column :loans, :amount_paid, :float, default: 0.0
  end
end
