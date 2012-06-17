class PricesController < ApplicationController
  include Sortable

  respond_to :html, :js, :json
  
  before_filter :get_company
  before_filter :authenticate_user!, :except => [:index, :show]

  def index

    if !@company
      @prices = Price.search(params[:q], :order => "company_id ASC, original_description ASC")
    else
      @prices = @company.prices.order(get_sort_settings_from_params).page(params[:page])
    end

    respond_with @prices
  end


  def show
    @price = @company.prices.find(params[:id])
    respond_with @price
  end

  def new
    respond_with(@price = @company.prices.build)
  end


  def edit
    respond_with(@price = @company.prices.find(params[:id]))
  end

  def create
    respond_with(@price = Price.new(params[:price]))
  end

  def update
    @price = @company.prices.find(params[:id])
    flash[:notice] = "Successfully updated price." if @price.update_attributes(params[:price])
    respond_with(@company, @price)
  end

  def destroy
    @price = @company.prices.find(params[:id])
    @price.destroy
    flash[:notice] = "Successfully destroyed price."
    respond_with(@price)
  end

  private

  def sort_column
    Price.column_names.include?(params[:sort]) ? params[:sort] : "original_description"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end

