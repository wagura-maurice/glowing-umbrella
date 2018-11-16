class AddStatusToCrops < ActiveRecord::Migration
  def change
    add_column :beans_reports, :status, :string, default: 'pending'
    add_column :black_eyed_beans_reports, :status, :string, default: 'pending'
    add_column :green_grams_reports, :status, :string, default: 'pending'
    add_column :maize_reports, :status, :string, default: 'pending'
    add_column :pigeon_peas_reports, :status, :string, default: 'pending'
    add_column :rice_reports, :status, :string, default: 'pending'
    add_column :soya_beans_reports, :status, :string, default: 'pending'

    MaizeReport.reset_column_information
    RiceReport.reset_column_information
    BeansReport.reset_column_information
    GreenGramsReport.reset_column_information
    BlackEyedBeansReport.reset_column_information
    SoyaBeansReport.reset_column_information
    PigeonPeasReport.reset_column_information

    i = 0
    Farmer.where(status: 'verified').find_each do |f|
      f.beans_reports.update_all(status: 'verified')
      f.black_eyed_beans_reports.update_all(status: 'verified')
      f.green_grams_reports.update_all(status: 'verified')
      f.maize_reports.update_all(status: 'verified')
      f.pigeon_peas_reports.update_all(status: 'verified')
      f.rice_reports.update_all(status: 'verified')
      f.soya_beans_reports.update_all(status: 'verified')
      i += 1

      if (i % 100) == 0
        puts "Processed farmers: #{i}"
      end
    end
  end
end
