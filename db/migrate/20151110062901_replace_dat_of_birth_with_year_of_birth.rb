class ReplaceDatOfBirthWithYearOfBirth < ActiveRecord::Migration
  def change
    add_column :farmers, :year_of_birth, :integer
    remove_column :farmers, :date_of_birth, :string
  end
end
