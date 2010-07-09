class PriceParser

  def self.normalize_description(desc)
    PriceDescriptionNormalizer.normalize_description(desc)
  end

  def self.find_company
    company = Company.find_by_name company_name
    company ||= Company.create :name => company_name
  end

end

