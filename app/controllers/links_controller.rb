# encoding: UTF-8
class LinksController < ApplicationController

  respond_to :html, :js, :json

  before_filter :authenticate_user!, :except => :index

  def index
    if params[:invalid]
      respond_with(@links = Link.with_multiple_items.includes(:price, :item).page(params[:page]))
    else
      respond_with(@links = Link.includes(:price, :item).page(params[:page]))
    end
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
      flash[:notice] = 'Связь создана.'
      if !other_prices.blank?
        @links << Link.create_many_links(other_prices, params[:link][:item_id])
        redirect_to :action => 'index', :id => @links.join('+'), :notice => 'Несколько связей создано.'
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
    flash[:notice] = 'Связь обновлена.' if @link.update_attributes(params[:link])
    respond_with(@link) 
  end

  def destroy
    @link = Link.find(params[:id])
    @link.destroy
    flash[:notice] = 'Связь разорвана.'
    respond_with(@link)
  end
  
end
