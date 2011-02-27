class SearchesController < ApplicationController

  def index
    if params[:q]
      company_param = { :with => {:company_id => company.id} } if params[:company_id]
      @prices = Price.search params[:q], company_param, :per_page => 25, :page => params[:page]
      @items = Item.search(params[:q], :per_page => 25, :page => params[:page])
      
      [@prices, @items].each do |a|
        def a.limit_value
          per_page
        end
        def a.num_pages
          @total_pages
        end
      end
    end
  end

end

