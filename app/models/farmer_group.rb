class FarmerGroup < ActiveRecord::Base

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
    return truncate(self.short_names)
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
    return [] if self.short_names.nil?
    names = self.short_names.split('|')
    farmers = []
    names.each do |name|
      farmers << Farmer.where("association_name ILIKE ?", name)
    end
    return farmers.flatten
  end

  def farmer_ids
    self.farmer_list.map { |val| val.id}
  end

  def genders
    ret = {}
    self.farmer_list.each do |farmer|
      gender = farmer.gender || 'not reported'
      if ret.has_key? gender
        ret[gender] += 1
      else
        ret[gender] = 1
      end
    end
    return ret
  end

  def ages
    ret = {'Youth' => 0, 'Adult' => 0, 'Unreported' => 0}
    year = Time.now.year
    self.farmer_list.each do |farmer|
      if farmer.year_of_birth.present?
        age = year - farmer.year_of_birth
        if age <= 35
          ret['Youth'] += 1
        else
          ret['Adult'] += 1
        end
      else
        ret['Unreported'] += 1
      end
    end
    return ret
  end

  def get_total(crop_report, report_type)
    ids = self.farmer_list.map { |val| val.id}
    reports = crop_report.where(farmer_id: ids).where(report_type: report_type)
    if report_type == 'planting'
      return reports.sum(:kg_of_seed_planted)
    elsif report_type == 'harvesting'
      return reports.sum(:bags_harvested)
    end
  end

end
