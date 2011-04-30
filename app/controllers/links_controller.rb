class LinksController < ApplicationController
  respond_to :html, :js

  def index
    respond_with(@links = Link.includes(:price, :item).page(params[:page]))
  end

  def show
    respond_with(@link = Link.find(params[:id]))
  end

  def new
    @link = Link.new(:price_id => params[:price_id], :human=> true, :score => 10)
    if params[:price_id]
      @price = Price.find params[:price_id]
      if @price.cross_prices.size > 0
        @price_that_can_be_linked = @price.cross_prices.select {|p| p.links.size == 0}      
      end
    end
    respond_with(@link)
  end

  def create
    @link = Link.new(params[:link])
    if @link.save
      flash[:notice] = "Successfully created link."
      if params[:link][:other_prices]
        other_prices = params[:link][:other_prices]
        other_prices.split(",").each do |price_id|
          Link.create(:price_id => price_id, :item_id => params[:link][:item_id], :human => true, :score => 10)
        end
        flash[:notice] = "Successfully created links."
      end
    end
    respond_with(@link, :layout => !request.xhr?)
  end

  def edit
    @link = Link.find(params[:id])
    respond_with(@link)
  end

  def update
    @link = Link.find(params[:id])
    flash[:notice] = "Successfully updated link." if @link.update_attributes(params[:link])
    respond_with(@link) 
  end

  def destroy
    @link = Link.find(params[:id])
    @link.destroy
    flash[:notice] = "Successfully destroyed link."
    respond_with(@link)
  end
  
end
