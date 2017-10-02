class Api::V1::FarmerSerializer < ActiveModel::Serializer
  attributes :phone_number,
    :association_name,
    :country,
    :county,
    :egranary_member_since,
    :name,
    :gender,
    :year_of_birth,
    :rec


    def egranary_member_since
      object.created_at
    end

    def reports
      beans_reports = object.beans_reports
      black_eyed_beans_reports = object.black_eyed_beans_reports
      green_grams_reports = object.black_eyed_beans_reports
      maize_reports = object.maize_reports
      nerica_rice_reports = object.nerica_rice_reports
      pigeon_peas_reports = object.pigeon_peas_reports
      rice_reports = object.rice_reports
      soya_beans_reports = object.soya_beans_reports
      reports = []
    end
end
