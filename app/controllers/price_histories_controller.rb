class PriceHistoriesController < ApplicationController
  def index
    @price_histories = PriceHistory.all
  end

  def show
    @price_history = PriceHistory.find(params[:id])
  end

  def new
    @price_history = PriceHistory.new
  end

  def create
    @price_history = PriceHistory.new(params[:price_history])
    if @price_history.save
      flash[:notice] = "Successfully created price history."
      redirect_to @price_history
    else
      render :action => 'new'
    end
  end

  def edit
    @price_history = PriceHistory.find(params[:id])
  end

  def update
    @price_history = PriceHistory.find(params[:id])
    if @price_history.update_attributes(params[:price_history])
      flash[:notice] = "Successfully updated price history."
      redirect_to price_history_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @price_history = PriceHistory.find(params[:id])
    @price_history.destroy
    flash[:notice] = "Successfully destroyed price history."
    redirect_to price_histories_url
  end
end
