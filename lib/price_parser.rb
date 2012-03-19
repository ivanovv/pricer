# encoding: UTF-8
require 'company_info'
class PriceParser
  include ::CompanyInfo

  attr_accessor :created_prices, :updated_prices, :total_prices, :total_rows

  def initialize
    @created_prices = 0
    @updated_prices = 0
    @total_prices = 0
    @total_rows = 0
    @price_saver = PriceSaver.new(company)
  end

  def create_price(price_attributes)
    @total_prices += 1
    price, action_taken = @price_saver.create_price(price_attributes)
    if action_taken == :create
      @created_prices +=1
    end
    if action_taken == :update
      @updated_prices +=1
    end
  end
end

