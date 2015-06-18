class AddReportTypeFieldToMaizeAndRiceReports < ActiveRecord::Migration
  def change
    add_column :maize_reports, :report_type, :string
    add_column :rice_reports, :report_type, :string
  end
end
