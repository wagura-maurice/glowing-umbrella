class AddingEvenMoreFeilds < ActiveRecord::Migration
  def change
    add_column :farmers, :group_registration_number, :string
  end
end
