class FarmerGroupsController < ApplicationController

  def create
    @farmer_group = FarmerGroup.create
    redirect_to edit_farmer_group_path(@farmer_group)
  end

  def edit
    upload_path = 'farmer_group_uploads/' + SecureRandom.uuid
    @id = params[:id]
    @s3_direct_post = AwsAdapter.get_s3_direct_post(upload_path)
    @farmer_group = FarmerGroup.find params[:id]
    @total_maize_bags_harvested = @farmer_group.get_total(MaizeReport, 'harvesting')
    @total_rice_bags_harvested = @farmer_group.get_total(RiceReport, 'harvesting')
    @total_bean_bags_harvested = @farmer_group.get_total(BeansReport, 'harvesting')
    @total_green_gram_bags_harvested = @farmer_group.get_total(GreenGramsReport, 'harvesting')
    @total_black_eyed_bean_bags_harvested = @farmer_group.get_total(BlackEyedBeansReport, 'harvesting')
    @total_soya_bean_bags_harvested = @farmer_group.get_total(SoyaBeansReport, 'harvesting')
    @total_pigeon_pea_bags_harvested = @farmer_group.get_total(PigeonPeasReport, 'harvesting')
    @total_maize_planted = @farmer_group.get_total(MaizeReport, 'planting')
    @total_rice_planted = @farmer_group.get_total(RiceReport, 'planting')
    @total_bean_planted = @farmer_group.get_total(BeansReport, 'planting')
    @total_green_gram_planted = @farmer_group.get_total(GreenGramsReport, 'planting')
    @total_black_eyed_bean_planted = @farmer_group.get_total(BlackEyedBeansReport, 'planting')
    @total_soya_bean_planted = @farmer_group.get_total(SoyaBeansReport, 'planting')
    @total_pigeon_pea_planted = @farmer_group.get_total(PigeonPeasReport, 'planting')
  end

  def update
    @fg = FarmerGroup.find(params[:id])
    @fg.update_attributes(params.require(:farmer_group).permit!)
    add_to_alert("Successfully updated Farmer Group", "success")
    redirect_to :action => :edit
  end

  def post_upload_audited_financials
    fg = FarmerGroup.find params['id'].to_i
    fg.audited_financials_upload_path = params["upload_path"]
    fg.save
    redirect_to :action => :edit, id: params['id'].to_i
  end

  def post_upload_management_accounts
    fg = FarmerGroup.find params['id'].to_i
    fg.management_accounts_upload_path = params["upload_path"]
    fg.save
    redirect_to :action => :edit, id: params['id'].to_i
  end

  def post_upload_certificate_of_registration
    fg = FarmerGroup.find params['id'].to_i
    fg.certificate_of_registration_upload_path = params["upload_path"]
    fg.save
    redirect_to :action => :edit, id: params['id'].to_i
  end

end
