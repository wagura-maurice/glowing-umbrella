class Api::V1::FarmerSerializer < ActiveModel::Serializer
  attributes :phone_number,
    :association_name,
    :country,
    :county,
    :registration_time,
    :name,
    :gender,
    :year_of_birth,
    :received_loans


  def reports
    instance_options[:farmer_reports]
  end

  has_many :reports, include_data: true, serializer: Api::V1::ReportSerializer
  has_many :loans, serializer: Api::V1::LoanSerializer
end
