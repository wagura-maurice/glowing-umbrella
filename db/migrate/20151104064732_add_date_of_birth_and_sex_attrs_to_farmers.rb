class AddDateOfBirthAndSexAttrsToFarmers < ActiveRecord::Migration
  def change
    add_column :farmers, :date_of_birth, :string
    add_column :farmers, :gender, :string
  end
end
