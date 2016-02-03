class CropController < ApplicationController

  # Action Methods

  def edit
    @record = model.find(params[:id])
  end


  def update
    @record = model.find(params[:id])
    @record.update_attributes(safe_params)
    add_to_alert("Successfully updated #{@model_name.titleize}", "success")
    redirect_to :action => :edit
  end


  def destroy
    @record = model.find(params[:id])
    @record.destroy
    add_to_alert("Successfully deleted #{@model_name.titleize}", "info")
    redirect_to records_table
  end


  # Utility Methods

  def model
    @model || get_model
  end

  def get_model
    @model_name = self.class.to_s.chomp('Controller').singularize
    @model = @model || Object.const_get(@model_name)
    @symbol = @model_name.underscore.to_sym
    return @model
  end

  def records_table
    @model_name.pluralize.concat('Table').underscore.to_sym
  end


  def safe_params
    get_model unless @symbol
    return params.require(@symbol).permit(:bags_harvested, :grade_1_bags, :grade_2_bags, :ungraded_bags, :kg_of_seed_planted)
  end


end
