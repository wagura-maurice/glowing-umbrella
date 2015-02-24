class CreateCropReportTables < ActiveRecord::Migration
  def change
    create_table :rice_reports do |t|
      t.float :acres_planted
      t.float :kg_of_seed_planted
      t.float :kg_stored
      t.string :rice_type
      t.string :grain_type
      t.string :aroma_type
      t.float :bags_to_sell
      t.float :kg_to_sell
      t.belongs_to :farmer, index: true
      t.timestamps null: false
    end

    create_table :maize_reports do |t|
      t.float :acres_planted
      t.float :kg_of_seed_planted
      t.string :maize_type
      t.string :grade
      t.float :bags_to_sell
      t.float :kg_to_sell
      t.belongs_to :farmer, index: true
      t.timestamps null: false
    end
  end
end
