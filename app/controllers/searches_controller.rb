class SearchesController < ApplicationController

  def index
    if params[:q]
      company_param = { :with => {:company_id => company.id} } if params[:company_id]
      @prices = Price.search params[:q], company_param, :per_page => 25, :page => params[:page]
      @items = Item.search(params[:q], :per_page => 25, :page => params[:page])
    end
    
    respond_to do |format|
      format.html 
      format.js  { render :xml => @price }
    end
  end

end

