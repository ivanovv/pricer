class SearchesController < ApplicationController

  def index
    if params[:company_id]
      @prices = Price.search params[:q], :with => {:company_id => company.id}, :per_page =>30, :page => params[:page]
    else
      @prices = Price.search params[:q], :per_page =>30, :page => params[:page]
    end
  end

end

