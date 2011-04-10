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
        update_price_history(price, price_attributes[:price].to_i)
        @updated_prices += 1
      else
        company.prices.create(price_attributes)
      end
    end

    def update_price_history(price, price_value)
      last_price_history = price.price_histories.order(:created_at).last
#      last_price_history = @price_histories.select do |price_history|
#        price_history.price_id == price.id
#      end.max {|a, b| a.created_at <=> b.created_at}
      if !last_price_history ||
        (last_price_history.value != price_value && last_price_history.created_at < 10.minutes.ago) then
        price.price_histories.create(:value => price_value)
        @created_prices += 1
      end
    end

end

