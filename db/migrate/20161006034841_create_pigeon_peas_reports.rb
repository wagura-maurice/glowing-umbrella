class CreatePigeonPeasReports < ActiveRecord::Migration
  def change
    unless table_exists? :pigeon_peas_reports
      create_table :pigeon_peas_reports do |t|
        t.float :kg_of_seed_planted
        t.float :acres_planted
        t.float :bags_harvested
        t.float :grade_1_bags
        t.float :grade_2_bags
        t.float :ungraded_bags
        t.string :report_type
        t.integer :season, index: true
        t.belongs_to :farmer, index: true
        t.belongs_to :pigeon_peas_reports, :harvest_report, index: true
        t.timestamps null: false
      end
    end
  end
end
