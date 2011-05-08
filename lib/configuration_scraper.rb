class ConfigurationScraper

  def initialize
    @agent = Mechanize.new
  end

  def company_name
    self.class::COMPANY_NAME
  end

  def company
    @company ||= Company.find_or_create_by_name company_name
    @company
  end

  def parse(record)
    scraped_configuration = scrape(record.url)
    Rails.logger.debug "title = #{scraped_configuration[:title]}"
    scraped_configuration[:prices].each do |price|
      Rails.logger.debug "price #{price[:price]}"
      record.configuration_lines.build(:price_id => price[:price].id, :quantity => 1, :price_value => price[:value])
    end

    set_record_properties(record, scraped_configuration)
    
  end


  def set_record_properties(record, config)
    record.name = config.try(:[], :title)
    record.total_price = config.try(:[], :total_price)
    record.assembly_price = config.try(:[], :assembly_price)
    record.company_id = company.id
  end

  def scrape(url)
    page = @agent.get(url)
    parse_page(page)
  end
end