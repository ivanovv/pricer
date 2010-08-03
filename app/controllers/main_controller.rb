class MainController < ApplicationController

  def index
    @price_count = Price.count
    @companies = Company.all
  end

  def about

  end
end

