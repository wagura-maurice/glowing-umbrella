class FarmerGroup < ActiveRecord::Base

  include ReportsKit::Model
  reports_kit do
    # dimension :farmer_count, where: 'farmer.'
  end

  def self.search_fields
    return {"created_at" => {type: :time, key: "Registration Date"},
            "updated_at" => {type: :time, key: "Record Update Date"},
            "short_names" => {type: :string, key: "Group Short Names"}
            }
  end

  def truncate(s, length = 30, ellipsis = '...')
    if s.length > length
      s.to_s[0..length].gsub(/[^\w]\w+\s*$/, ellipsis)
    else
      s
    end
  end

  def truncated_short_names
    if self.short_names
      return truncate(self.short_names)
    else
      return self.short_names
    end
  end


  def audited_financials_url
    if self.audited_financials_upload_path.present?
      return AwsAdapter.get_public_url(self.audited_financials_upload_path)
    end
  end

  def management_accounts_url
    if self.management_accounts_upload_path.present?
      return AwsAdapter.get_public_url(self.management_accounts_upload_path)
    end
  end

  def certificate_of_registration_url
    if self.certificate_of_registration_upload_path.present?
      return AwsAdapter.get_public_url(self.certificate_of_registration_upload_path)
    end
  end

  def farmer_list
    return @farmer_list if @farmer_list.present?
    return FarmerGroup.none if self.short_names.blank?
    names = self.short_names.split('|')
    arr = []
    names.each do |name|
      arr << "%#{name}%"
    end
    @farmer_list = Farmer.where("association_name ILIKE any ( array[?] )", arr)
    self.approx_farmer_count = @farmer_list.count
    self.save
    return @farmer_list
  end

  def farmer_ids
    @farmer_ids ||= self.farmer_list.pluck(:id)
  end

  def genders
    genders = self.farmer_list.group(:gender).count
    genders.delete(nil)
    return genders
  end

  def ages
    ret = {
      'Youth' => self.farmer_list.where('year_of_birth >= ?', Time.now.year - 35).count,
      'Adult' => self.farmer_list.where('year_of_birth < ?', Time.now.year - 35).count
    }
    return ret
  end

  def get_total(crop_report, report_type)
    ids ||= self.farmer_ids
    reports = crop_report.where(farmer_id: ids).where(report_type: report_type)
    if report_type == 'planting'
      return reports.sum(:kg_of_seed_planted)
    elsif report_type == 'harvesting'
      return reports.sum(:bags_harvested)
    end
  end

end
