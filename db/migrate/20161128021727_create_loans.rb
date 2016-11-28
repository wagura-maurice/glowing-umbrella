class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.string :loan_type
      t.float :amount
      t.integer :season
      t.datetime :disbursed_date
      t.datetime :repaid_date
      t.float :service_charge
      t.string :disbursal_method
      t.string :repayment_method
      t.string :voucher_code
      t.belongs_to :farmer, index: true
      t.timestamps null: false
    end
  end
end
