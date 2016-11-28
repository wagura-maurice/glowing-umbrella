module FormValidation

  # Valid response types
  RESPONSE_TYPES = [:any, :any_number, :unique_id_number, :any_letters, :any_year,
                    :less_than_bags_harvested, :less_than_bags_harvested_and_pishori,
                    :less_than_bags_harvested_minus_grade_1, :less_than_bags_harvested_and_pishori_and_super,
                    :less_than_bags_harvested_minus_grade_1_and_2, :valid_pin,
                    :authenticate_national_id, :authenticate_pin]


  ####################################
  ### Validation Utility Functions ###
  ####################################

  # The following functions validate the nunber of bags for a given crop
  def less_than_bags_harvested
    @response = @response.to_f
    bags_harvested = @session[:bags_harvested].to_f
    return @response <= bags_harvested
  end


  def less_than_bags_harvested_minus_grade_1
    @response = @response.to_f
    bags_harvested = @session[:bags_harvested].to_f
    grade_1_bags = @session[:grade_1_bags].to_f
    return @response <= bags_harvested - grade_1_bags
  end


  def less_than_bags_harvested_minus_grade_1_and_2
    @response = @response.to_f
    bags_harvested = @session[:bags_harvested].to_f
    grade_1_bags = @session[:grade_1_bags].to_f
    grade_2_bags = @session[:grade_2_bags].to_f
    return @response <= bags_harvested - grade_1_bags - grade_2_bags
  end


  def less_than_bags_harvested_and_pishori
    @response = @response.to_f
    bags_harvested = @session[:bags_harvested].to_f
    pishori_bags = @session[:pishori_bags].to_f
    return @response <= bags_harvested - pishori_bags
  end


  def less_than_bags_harvested_and_pishori_and_super
    @response = @response.to_f
    bags_harvested = @session[:bags_harvested].to_f
    pishori_bags = @session[:pishori_bags].to_f
    super_bags = @session[:super_bags].to_f
    return @response <= bags_harvested - pishori_bags - super_bags
  end


  def valid_pin(pin)
    return pin.length == 5
  end

  # Validate county
  def self.valid_county
    @response = @response.downcase
    return kenyan_counties.has_key? @response
  end


  # Valid county keys
  def kenyan_counties
    counties = {"mombasa" => "Mombasa",
                "kwale" => "Kwale",
                "kilifi" => "Kilifi",
                "tana river" => "Tana River",
                "tana" => "Tana River",
                "lamu" => "Lamu",
                "taita-taveta" => "Taita-Taveta",
                "taita taveta" => "Taita-Taveta",
                "taita" => "Taita-Taveta",
                "taveta" => "Taita-Taveta",
                "garissa" => "Garissa",
                "wajir" => "Wajir",
                "mandera" => "Mandera",
                "marsabit" => "Marsabit",
                "isiolo" => "Isiolo",
                "meru" => "Meru",
                "tharaka-nithi" => "Tharaka-Nithi",
                "tharaka nithi" => "Tharaka-Nithi",
                "tharaka" => "Tharaka-Nithi",
                "nithi" => "Tharaka-Nithi",
                "embu" => "Embu",
                "kitui" => "Kitui",
                "machakos" => "Machakos",
                "makueni" => "Makueni",
                "nyandarua" => "Nyandarua",
                "nyeri" => "Nyeri",
                "kirinyaga" => "Kirinyaga",
                "murang'a" => "Muranga",
                "muranga" => "Muranga",
                "kiambu" => "Kiambu",
                "turkana" => "Turkana",
                "west pokot" => "West Pokot",
                "pokot" => "West Pokot",
                "samburu" => "Samburu",
                "trans nzoia" => "Trans Nzoia",
                "transnzoia" => "Trans Nzoia",
                "nzoia" => "Trans Nzoia",
                "trans" => "Trans Nzoia",
                "uasin gishu" => "Uasin Gishu",
                "gishu" => "Uasin Gishu",
                "uasin" => "Uasin Gishu",
                "elgeyo-marakwet" => "Elgeyo-Marakwet",
                "elgeyo marakwet" => "Elgeyo-Marakwet",
                "elgeyo" => "Elgeyo-Marakwet",
                "marakwet" => "Elgeyo-Marakwet",
                "nandi" => "Nandi",
                "baringo" => "Baringo",
                "laikipia" => "Laikipia",
                "nakuru" => "Nakuru",
                "narok" => "Narok",
                "kajiado" => "Kajiado",
                "kericho" => "Kericho",
                "bomet" => "Bomet",
                "kakamega" => "Kakamega",
                "vihiga" => "Vihiga",
                "bungoma" => "Bungoma",
                "busia" => "Busia",
                "siaya" => "Siaya",
                "kisumu" => "Kisumu",
                "homa bay" => "Homa Bay",
                "migori" => "Migori",
                "kisii" => "Kisii",
                "nyamira" => "Nyamira",
                "nairobi" => "Nairobi"}
    return counties
  end


end