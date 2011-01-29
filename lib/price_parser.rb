# encoding: UTF-8
class PriceParser

  def company_name
    self.class::COMPANY_NAME
  end

  def company
    @company ||= Company.find_or_create_by_name company_name
  end

  def create_price(price_attributes)
    search_term = valid_warehouse_code?(price_attributes[:warehouse_code]) ?  :warehouse_code : :original_description
    create_or_update_price_history(search_term, price_attributes)
  end

  private

    def valid_warehouse_code?(code)
      code && !code.blank?
    end

    def create_or_update_price_history(search_term, price_attributes)
      prices = company.prices.where(search_term => price_attributes[search_term])
      if prices.count > 0
        update_price_history(prices, price_attributes[:price].to_i)
      else
        company.prices.create(price_attributes)
      end
    end


    def update_price_history(prices, price_value)
      prices.each do |p|
        last_price_history = p.price_histories.order(:created_at).last
        if !last_price_history ||
          (last_price_history.value != price_value && last_price_history.created_at < 10.minutes.ago) then
          price_history = p.price_histories.create(:value => price_value)
        end
      end
    end

end

