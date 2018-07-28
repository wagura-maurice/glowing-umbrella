module Exportable
  extend ActiveSupport::Concern

  included do

    def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << export_attributes
        all.each do |farmer|
          csv << farmer.attributes.values_at(*export_attributes)
        end
      end
    end

  end

  class_methods do

    def export_attributes
      if self == Farmer
        return %w{id name phone_number national_id_number association_name country county nearest_town gender year_of_birth farm_size created_at updated_at status}
      else
        dont_show = ["acres_planted", "maize_type", "grade", "bags_to_sell", "kg_to_sell", "kg_stored", "rice_type", "grain_type", "aroma_type"]
        return column_names - dont_show
      end
    end

  end



end