class PriceParser

  def normalize_description(desc)
    PriceDescriptionNormalizer.normalize_description(desc)
  end

  def company
    @company ||= Company.find_or_create_by_name company_name
  end

  def create_price(price_attributes)
    wh_code = price_attributes[:warehouse]
    company.prices.create(price_attributes) unless company.prices.find_by_warehouse_code(wh_code)
  end

end

