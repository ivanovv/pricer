# encoding: UTF-8
class PriceParser

  def company_name
    self.class::COMPANY_NAME
  end

  def company
    @company ||= Company.find_or_create_by_name company_name
  end

  def create_price(price_attributes)
    if valid_warehouse_code? price_attributes[:warehouse]
      find_or_create_by_warehouse_code price_attributes
    else
      find_or_create_by_original_description price_attributes
    end
  end

  private

  def valid_warehouse_code?(code)
    code && !code.blank?
  end

  def find_or_create_by_warehouse_code(price_attributes)
    unless company.prices.find_by_warehouse_code(price_attributes[:warehouse])
      company.prices.create(price_attributes)
    end
  end

  def find_or_create_by_original_description(price_attributes)
    unless company.prices.find_by_original_description(price_attributes[:original_description])
      company.prices.create(price_attributes)
    end
  end

end

