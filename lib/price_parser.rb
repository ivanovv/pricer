# encoding: UTF-8
class PriceParser

  def company_name
    self.class::COMPANY_NAME
  end

  def company
    @company ||= Company.find_or_create_by_name company_name
  end

  def create_price(price_attributes)
    search_term = valid_warehouse_code?(price_attributes[:warehouse]) ?  :warehouse : :original_description
    create_or_update_price_history(search_term, price_attributes)
  end

  private

    def valid_warehouse_code?(code)
      code && !code.blank?
    end

    def create_or_update_price_history(search_term, price_attributes)
      price = company.prices.where(search_term => price_attributes[search_term])
      if price.count > 0
        price.each do |p|
          last_price_history = p.price_histories.order(:created_at).last
          if !last_price_history ||
              (last_price_history.value != price_attributes[:price].to_i && last_price_history.created_at < 10.minutes.ago)  then
            price_history = p.price_histories.create(:value => price_attributes[:price])
          end
        end
      else
        company.prices.create(price_attributes)
      end
    end

    def find_or_create_by_original_description(price_attributes)
      unless company.prices.find_by_original_description(price_attributes[:original_description])
        company.prices.create(price_attributes)
      end
    end
end

