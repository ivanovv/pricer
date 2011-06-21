class ItemsController < ApplicationController
  before_filter :authenticate_user!, :except => :index

  def index
    @items = Item.order(:original_description).page(params[:page])
  end

  def show
    @item = Item.find(params[:id])
    @prices_links = []
    @item.prices.each do |price|
      link = Link.find_by_item_id_and_price_id(@item.id, price.id)
      @prices_links << {:price => price, :link => link}
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params[:item])
    if @item.save
      flash[:notice] = "Successfully created item."
      redirect_to @item
    else
      render :action => 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      flash[:notice] = "Successfully updated item."
      redirect_to item_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed item."
    redirect_to items_url
  end
end
