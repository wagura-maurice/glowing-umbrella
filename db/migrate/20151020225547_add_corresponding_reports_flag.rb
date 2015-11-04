class AddCorrespondingReportsFlag < ActiveRecord::Migration
  def change
    add_reference :black_eyed_beans_reports, :harvest_report, index: true
    add_reference :beans_reports, :harvest_report, index: true
    add_reference :green_grams_reports, :harvest_report, index: true
    add_reference :maize_reports, :harvest_report, index: true
    add_reference :nerica_rice_reports, :harvest_report, index: true
    add_reference :rice_reports, :harvest_report, index: true
  end
end
