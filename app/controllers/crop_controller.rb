class CropController < ApplicationController

  include ModelSearch

  def upload_button
    upload_path = 'crop_uploads/' + SecureRandom.uuid
    @s3_direct_post = AwsAdapter.get_s3_direct_post(upload_path)
  end

  def upload_data
    UploadCropDataWorker.perform_async(params[:upload_path], current_user.email)
    add_to_alert("Uploading data. You will receive a status update at #{current_user.email} shortly.", "info")
    redirect_to :app
  end

  # Action Methods

  def index
    if params['unscoped'] == 'true'
      @all_models = model.unscoped.order(:created_at)
    else
      @all_models = model.order(:created_at)
    end

    respond_to do |format|
      format.html
      format.csv { send_data @all_models.to_csv }
      format.xls do
        # records = run_queries(model, params)
        # send_data records.to_csv(col_sep: "\t")

        EmailExcelDataWorker.perform_async(model.to_s, current_user.email, params)
        add_to_alert("Check your email #{current_user.email} in a few minutes with the exported data", "success")
        redirect_to records_table
      end
    end
  end

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
