class CreateSoyaBeansReports < ActiveRecord::Migration
  def change
    unless table_exists? :soya_beans_reports
      create_table :soya_beans_reports do |t|
        t.float :kg_of_seed_planted
        t.float :acres_planted
        t.float :bags_harvested
        t.float :grade_1_bags
        t.float :grade_2_bags
        t.float :ungraded_bags
        t.string :report_type
        t.integer :season, index: true
        t.belongs_to :farmer, index: true
        t.belongs_to :soya_beans_reports, :harvest_report, index: true
        t.timestamps null: false
      end
    end
  end
end
