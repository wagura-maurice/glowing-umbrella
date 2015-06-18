class CreateBlackEyedBeansReports < ActiveRecord::Migration
  def change
    create_table :black_eyed_beans_reports do |t|
      t.float :kg_of_seed_planted
      t.float :bags_harvested
      t.float :grade_1_bags
      t.float :grade_2_bags
      t.float :ungraded_bags
      t.string :report_type
      t.belongs_to :farmer, index: true
      t.timestamps null: false
    end
  end
end
