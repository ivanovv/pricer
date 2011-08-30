class LinksController < ApplicationController

  respond_to :html, :js, :json

  before_filter :authenticate_user!, :except => :index

  def index
    respond_with(@links = Link.includes(:price, :item).page(params[:page]))
  end

  def show
    @links = Array(Link.find(params[:id].split('+')))
    respond_with(@links)
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
    @links = []
    other_prices = params[:link][:other_prices]
    @link = Link.new(params[:link])
    if @link.save
      flash[:notice] = "Successfully created link."
      if other_prices && !other_prices.blank?
        @links << Link.create_many_links(other_prices, params[:link][:item_id])
        flash[:notice] = "Successfully created several links."
        redirect_to :action => 'index', :id => @links.map{ |link| link.id}.join('+')
      else
        respond_with(@link, :layout => !request.xhr?)
      end
    end
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
