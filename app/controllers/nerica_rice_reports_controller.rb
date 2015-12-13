class NericaRiceReportsController < CropController

  def safe_params
    get_model unless @symbol
    return params.require(@symbol).permit(:bags_harvested, :pishori_bags, :super_bags, :other_bags, :kg_of_seed_planted)
  end

end
