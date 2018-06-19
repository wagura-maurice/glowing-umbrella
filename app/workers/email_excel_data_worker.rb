require 'upload_farmer_data'
require 'aws_adapter'

class EmailExcelDataWorker
  include Sidekiq::Worker
  include ModelSearch

  sidekiq_options retry: 0

  def perform(model_name, email, params)
    puts "PARAMS"
    puts params
    model = get_model(model_name)

    if params['unscoped'] == 'true'
      @all_models = model.unscoped.order(:created_at)
    else
      @all_models = model.order(:created_at)
    end

    records = run_queries(model, params)
    data = records.to_csv(col_sep: "\t")
    file_name = model.to_s + "-" + SecureRandom.uuid
    File.open(file_name, "w"){ |f| f << data }
    upload_path = 'excel_downloads/' + file_name
    AwsAdapter.upload_file(upload_path, file_name)
    public_url = AwsAdapter.get_public_url(upload_path)

    # Send email about download
    UploadMailer.download_email(email, public_url).deliver_now
  end

  def get_model(model_name)
    model_name = self.class.to_s.chomp('Controller').singularize
    model = Object.const_get(model_name)
    return model
  end


end
