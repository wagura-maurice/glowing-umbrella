class DashboardController < ApplicationController
  require 'AfricasTalkingGateway'
  require 'send_messages'

  def index
    @farmers = Farmer.all.order("updated_at DESC")
    @rice_farmers_count =  Farmer.where("'rice' = ANY (crops)").count
    @maize_farmers_count = Farmer.where("'maize' = ANY (crops)").count
    @total_maize_bags_harvested = MaizeReport.sum :bags_harvested
    @total_rice_bags_harvested = RiceReport.sum :bags_harvested
    @rice_reports = RiceReport.all.order("updated_at DESC")
    @maize_reports = MaizeReport.all.order("updated_at DESC")
  end

  def farmers_table
    ret = FarmerDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def maize_reports_table
    ret = MaizeReportDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def rice_reports_table
    ret = RiceReportDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def blast
    debugger
    if params["send_messages_to"] == "1"
      to = Farmer.pluck(:phone_number).uniq
    elsif params["send_messages_to"] == "2"
      Farmer.where("'maize' = ANY (crops)").pluck(:phone_number).uniq
    elsif params["send_messages_to"] == "3"
      Farmer.where("'rice' = ANY (crops)").pluck(:phone_number).uniq
    end
    unless Rails.env.development?
      SendMessages.send(to, 'Jiunga', params["message"])
    end
    redirect_to :controller => :dashboard, :action => :index
  end

end
