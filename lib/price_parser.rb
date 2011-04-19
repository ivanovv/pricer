# encoding: UTF-8
class PriceParser

  def initialize
    @created_prices = 0
    @updated_prices = 0
    @total_prices = 0
  end

  def company_name
    self.class::COMPANY_NAME
  end

  def company
    @company ||= Company.find_or_create_by_name company_name
    #@prices ||= @company.prices.all
    #TODO select only one price_history record (to get rid of max)
    #@price_histories ||= PriceHistory.from("`price_histories`, `prices`").where("price_histories.price_id = prices.id and prices.company_id = ?", [@company.id]).all

    @company
  end

  def create_price(price_attributes)
    @total_prices += 1
    search_term = valid_warehouse_code?(price_attributes[:warehouse_code]) ?  :warehouse_code : :original_description
    price_attributes[:web_link] = @company.make_short_link(price_attributes[:web_link])
    create_or_update_price_history(search_term, price_attributes)
  end

  private

    def valid_warehouse_code?(code)
      code && !code.blank?
    end

    def create_or_update_price_history(search_term, price_attributes)
      price = company.prices.where(search_term => price_attributes[search_term]).first
#      price = @prices.find {|price|
#        price[search_term] == price_attributes[search_term]
#      }
      if price
        price.update_original_description(price_attributes[:original_description].to_s)
        @updated_prices += 1
      else
        price = company.prices.create(price_attributes)
        @created_prices += 1
      end
      price.update_price_history(price_attributes[:price].to_i)
    end

end

