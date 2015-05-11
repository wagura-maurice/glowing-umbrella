class ConvertFarmerFirstAndLastNamesToFullName < ActiveRecord::Migration
  def change
    add_column :farmers, :name, :string


    Farmer.all.each do |f|
      if f.first_name.present? and f.last_name.present?
        f.name = [f.first_name, f.last_name].join(' ')
      elsif f.first_name.nil? and f.last_name.present?
        f.name = f.last_name
      elsif f.first_name.present? and f.last_name.nil?
        f.name = f.first_name
      end
      f.save
    end

    remove_column :farmers, :first_name
    remove_column :farmers, :last_name

  end
end
