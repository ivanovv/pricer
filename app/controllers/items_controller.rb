class ItemsController < ApplicationController

  respond_to :html, :json

  before_filter :authenticate_user!, :except => :index

  def index
    if params[:q]
      @items = Item.search(params[:q], :order => :original_description)
    else
      @items = Item.order(:original_description).page(params[:page])
    end
    respond_with(@items)
  end

  def show
    @item = Item.find(params[:id])
    @prices_links = []
    @item.prices.each do |price|
      link = Link.find_by_item_id_and_price_id(@item.id, price.id)
      @prices_links << {:price => price, :link => link}
    end
    respond_with(@item, @prices_links)
  end

  def new
    respond_with(@item = Item.new)
  end

  def create
    @item = Item.new(params[:item])
    flash[:notice] = "Successfully created item." if @item.save
    respond_with(@item)
  end

  def edit
    respond_with(@item = Item.find(params[:id]))
  end

  def update
    @item = Item.find(params[:id])
    flash[:notice] = "Successfully updated item." if @item.update_attributes(params[:item])
    respond_with(@item)
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed item."
    respond_with @item
  end
end
