class FarmerGroupCounterWorker
  include Sidekiq::Worker

  sidekiq_options retry: 0

  def perform
    FarmerGroup.all.each do |fg|
      fg.farmer_list.count
    end
  end


end
