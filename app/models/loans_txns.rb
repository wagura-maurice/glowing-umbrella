class LoansTxns < ActiveRecord::Base
  belongs_to :loan
  belongs_to :txn
end