module CropBase
  extend ActiveSupport::Concern

  def reporting_time
    self.created_at.strftime("%H:%M %p %d/%m/%y")
  end

  def is_planting?
    self.report_type == "planting"
  end

  def is_harvest?
    self.report_type == "harvest"
  end

  def is_input?
    self.report_type == "input"
  end

end