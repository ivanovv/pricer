class LinksController < ApplicationController
  def index
    @links = Link.includes(:price, :item).page(params[:page])
  end

  def show
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new(:price_id => params[:price_id], :human=> true, :score => 10)
    if params[:price_id]
      @price = Price.find params[:price_id]
    end
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

      redirect_to @link
    else
      render :action => 'new'
    end
  end

  def edit
    @link = Link.find(params[:id])
  end

  def update
    @link = Link.find(params[:id])
    if @link.update_attributes(params[:link])
      flash[:notice] = "Successfully updated link."
      redirect_to link_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @link = Link.find(params[:id])
    @link.destroy
    flash[:notice] = "Successfully destroyed link."
    redirect_to links_url
  end
end
