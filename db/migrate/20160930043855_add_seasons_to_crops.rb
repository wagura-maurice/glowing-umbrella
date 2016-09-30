class AddSeasonsToCrops < ActiveRecord::Migration
  def change
    add_column :black_eyed_beans_reports, :season, :integer
    add_column :beans_reports, :season, :integer
    add_column :green_grams_reports, :season, :integer
    add_column :maize_reports, :season, :integer
    add_column :nerica_rice_reports, :season, :integer
    add_column :rice_reports, :season, :integer

    BlackEyedBeansReport.update_all(season: 1)
    BeansReport.update_all(season: 1)
    GreenGramsReport.update_all(season: 1)
    MaizeReport.update_all(season: 1)
    NericaRiceReport.update_all(season: 1)
    RiceReport.update_all(season: 1)

  end
end
