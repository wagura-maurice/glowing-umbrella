class Txn < ActiveRecord::Base
  belongs_to :farmer
  has_and_belongs_to_many :loans

  def self.search_fields
    return {"value" => {type: :number, key: "Value"},
            "account_id" => {type: :string, key: "Account ID"},
            "completed_at" => {type: :string, key: "Completed At"},
            "name" => {type: :string, key: "Name"},
            "txn_type" => {type: :string, key: "Type"},
            "phone_number" => {type: :string, key: "Phone Number"}
            }
  end
end
