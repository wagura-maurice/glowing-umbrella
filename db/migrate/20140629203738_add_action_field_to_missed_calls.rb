class AddActionFieldToMissedCalls < ActiveRecord::Migration
  def change
    add_column :missed_calls, :action, :string
  end
end
