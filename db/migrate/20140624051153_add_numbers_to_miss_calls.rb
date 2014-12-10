class AddNumbersToMissCalls < ActiveRecord::Migration
  def change
    add_column :missed_calls, :from, :string
    add_column :missed_calls, :to, :string
  end
end
