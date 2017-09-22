class AddNewLoansTable < ActiveRecord::Migration

  def change
    rename_table :loans, :old_loans

    create_table :loans do |t|
      t.string :commodity
      t.json :commodities_lent
      t.float :value
      t.string :time_period
      t.integer :season
      t.integer :year
      t.float :interest_rate
      t.string :interest_period
      t.string :interest_type
      t.integer :duration
      t.string :duration_unit
      t.string :currency
      t.float :service_charge
      t.string :structure
      t.string :status
      t.datetime :disbursed_date
      t.datetime :repaid_date
      t.string :disbursal_method
      t.string :repayment_method
      t.string :voucher_code
      t.belongs_to :farmer, index: true
      t.timestamps null: false
    end

    add_column :farmers, :received_loans, :boolean, default: false

    # Get rid of old pins and store new encrypted pins
    remove_column :farmers, :pin, :string
    add_column :farmers, :pin_hash, :string

  end
end
