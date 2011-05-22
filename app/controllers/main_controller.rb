class MainController < ApplicationController

  caches_page :index
  
  def index
    expires_in seconds_till_next_price_upload, :public => true
    @price_count = Price.count
    @companies = Company.all
  end

  def about

  end

  private
  def seconds_till_next_price_upload
    start_date = Time.now.hour < 5 ? Time.now : Time.now.tomorrow
    (start_date.change(:hour => 5) - Time.now).to_i
  end
  
end

