class PriceSaver

  def initialize(company)
    @company = company
  end

  def create_price(price_attributes)
    desc = price_attributes[:original_description]
    price_attributes[:description] = PriceDescriptionNormalizer.normalize_description(desc)
    price_attributes[:company_id] = @company.id
    search_term = valid_warehouse_code?(price_attributes[:warehouse_code]) ?  :warehouse_code : :original_description
    price_attributes[:web_link] = @company.make_short_link(price_attributes[:web_link])
    create_or_update_price_history(search_term, price_attributes)
  end

  private

  def valid_warehouse_code?(code)
    code && !code.blank?
  end

  def create_or_update_price_history(search_term, price_attributes)
    price = @company.prices.where(search_term => price_attributes[search_term]).first

    if price
      price_was_updated = price.update_original_description(price_attributes[:original_description].to_s)
      if price_attributes[:web_link] && !price.web_link
        price.update_attribute(:web_link, price_attributes[:web_link])
        price_was_updated = true
      end
    else
      price = @company.prices.create(price_attributes)
      action = :create
    end
    history_updated = price.update_price_history(price_attributes[:price].to_i)
    if (price_was_updated || history_updated) && action != :create then
      action = :update
    end
    [price, action]
  end
end