# encoding: UTF-8
class MainController < ApplicationController

  #caches_action :index, :layout => false
  
  def index
    @price_count = Price.count
    @config_count = ScrapedConfiguration.count
    @companies = Company.all
    @config_counts = ScrapedConfiguration.group(:company_id).count
    @price_counts = Price.group(:company_id).count
  end

  def about

  end

  private
  def seconds_till_next_price_upload
    start_date = Time.now.hour < 5 ? Time.now : Time.now.tomorrow
    (start_date.change(:hour => 5) - Time.now).to_i
  end
  
end

