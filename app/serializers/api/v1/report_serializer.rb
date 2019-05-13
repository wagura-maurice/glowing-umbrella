class Api::V1::ReportSerializer < ActiveModel::Serializer
  attributes :crop_type,
    :report_type

  attribute :kg_of_seed_planted, if: :is_planting?

  attribute :bags_harvested, if: :is_harvest?

  attribute :reporting_time

  def crop_type
    object.class.to_s[0..-7].underscore.downcase
  end

  def report_type
    if object.is_planting?
      return 'planting'
    elseif object.is_harvest?
      return 'harvest'
    elseif object.is_input?
      return 'input'
    end   
  end

  def is_planting?
    return object.is_planting?
  end

  def is_harvest?
    return object.is_harvest?
  end

  def is_input?
    return object.is_input?
  end

end
