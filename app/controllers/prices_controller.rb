class PricesController < ApplicationController

  respond_to :html, :js, :json
  
  before_filter :get_company
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    sort = case params['sort']
             when "name" then
               "original_description"
             when "recent" then
               "created_at desc"
           end

    sort ||= "created_at desc"

    if !@company
      @prices = Price.search(params[:q], :order => "company_id ASC, original_description ASC")
    else
      @prices = @company.prices.order(sort).page(params[:page])
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
    respond_with(@price)
  end

  def destroy
    @price = @company.prices.find(params[:id])
    @price.destroy
    flash[:notice] = "Successfully destroyed price."
    respond_with(@price)
  end

  private

  def get_company
    @company = begin Company.find params[:company_id] rescue nil end
  end

  def sort_column
    Price.column_names.include?(params[:sort]) ? params[:sort] : "original_description"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end

