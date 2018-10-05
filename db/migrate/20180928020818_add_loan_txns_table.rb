class AddLoanTxnsTable < ActiveRecord::Migration
  def change

    create_table :loans_txns, id: false do |t|
      t.belongs_to :loan, index: true
      t.belongs_to :txn, index: true
      t.float :amount_paid, default: 0.0
    end

  end
end
