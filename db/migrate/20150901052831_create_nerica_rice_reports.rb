class CreateNericaRiceReports < ActiveRecord::Migration
  def change
    create_table :nerica_rice_reports do |t|
      t.float :kg_of_seed_planted
      t.float :acres_planted
      t.float :kg_of_seed_planted
      t.float :bags_harvested
      t.float :pishori_bags
      t.float :super_bags
      t.float :other_bags
      t.string :report_type
      t.belongs_to :farmer, index: true
      t.timestamps null: false
    end
  end
end
