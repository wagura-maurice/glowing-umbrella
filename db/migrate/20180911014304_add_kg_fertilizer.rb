class AddKgFertilizer < ActiveRecord::Migration
  def change
    add_column :beans_reports, :kg_of_fertilizer, :float
    add_column :black_eyed_beans_reports, :kg_of_fertilizer, :float
    add_column :green_grams_reports, :kg_of_fertilizer, :float
    add_column :maize_reports, :kg_of_fertilizer, :float
    add_column :pigeon_peas_reports, :kg_of_fertilizer, :float
    add_column :rice_reports, :kg_of_fertilizer, :float
    add_column :soya_beans_reports, :kg_of_fertilizer, :float
  end
end
