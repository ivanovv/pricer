# encoding: UTF-8
class PriceHistoriesController < ApplicationController
  respond_to :html
  
  def index
    respond_with(@price_histories = PriceHistory.all)
  end

  def show
    respond_with(@price_history = PriceHistory.find(params[:id]))
  end

  def new
    respond_with(@price_history = PriceHistory.new)
  end

  def create
    @price_history = PriceHistory.new(params[:price_history])
    flash[:notice] = "Successfully created price history." if @price_history.save
    respond_with(@price_history)
  end

  def edit
    respond_with(@price_history = PriceHistory.find(params[:id]))
  end

  def update
    @price_history = PriceHistory.find(params[:id])
    flash[:notice] = "Successfully updated price history." if @price_history.update_attributes(params[:price_history])
    respond_with(@price_history)
  end

  def destroy
    @price_history = PriceHistory.find(params[:id])
    @price_history.destroy
    flash[:notice] = "Successfully destroyed price history."
    respond_with(@price_history)
  end
end
