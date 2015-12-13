module CropBase
  extend ActiveSupport::Concern

  def reporting_time
    self.created_at.strftime("%H:%M %p %d/%m/%y")
  end

  def is_planting?
    self.report_type == "planting"
  end

end