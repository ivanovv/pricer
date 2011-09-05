class PricesController < ApplicationController

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

    @prices = @company.prices.order(sort).page(params[:page])

    respond_to do |format|
      format.html
      format.xml { render :xml => @prices }
    end
  end


  def show
    @price = @company.prices.find(params[:id])
    respond_to do |format|
      format.html
      format.xml { render :xml => @price }
    end
  end

  def new
    @price = @company.prices.build

    respond_to do |format|
      format.html
      format.xml { render :xml => @price }
    end
  end


  def edit
    @price = @company.prices.find(params[:id])
  end

  def create
    @price = Price.new(params[:price])

    respond_to do |format|
      if @price.save
        format.html { redirect_to([@company, @price], :notice => 'Price was successfully created.') }
        format.xml { render :xml => @price, :status => :created, :location => @price }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @price.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @price = @company.prices.find(params[:id])

    respond_to do |format|
      if @price.update_attributes(params[:price])
        format.html { redirect_to([@company, @price], :notice => 'Price was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @price.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @price = @company.prices.find(params[:id])
    @price.destroy

    respond_to do |format|
      format.html { redirect_to(company_prices_url(@company)) }
      format.xml { head :ok }
    end
  end

  private

  def get_company
    @company = Company.find params[:company_id] || Company.first
  end

  def sort_column
    Price.column_names.include?(params[:sort]) ? params[:sort] : "original_description"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end

