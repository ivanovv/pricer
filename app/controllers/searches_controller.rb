class SearchesController < ApplicationController

  def index
    if params[:q]
      company_param = { :with => {:company_id => company.id} } if params[:company_id]
      @prices = Price.search params[:q], company_param, :per_page => 30, :page => params[:page]
    end
  end

end

