class FarmerInput < ActiveRecord::Base
  belongs_to :user

  def commodity
    case self.commodity_number
    when 1
      "Coffee"
    when 2
      "Tea"
    when 3
      "Cabbage"
    when 4
      "Mangoes"
    when 5
      "Bananas"
    else
      nil
    end
  end

  def grade
    case self.commodity_grade
    when 1
      "Speciality"
    when 2
      "Premium"
    when 3
      "Exchange"
    when 4
      "Standard"
    when 5
      "Off Grade"
    else
      nil
    end
  end

end
