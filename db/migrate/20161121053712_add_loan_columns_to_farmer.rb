class AddLoanColumnsToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :accepted_loan_tnc, :boolean, default: false
    add_column :farmers, :pin, :string
  end
end
