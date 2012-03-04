class ConfigurationScraper

  include ::CompanyInfo

  def parse(url_or_page)
    scraped_configuration = get_configuration(url_or_page)
    scraped_configuration[:company_id] = company.id
    scraped_configuration
  end

  def get_configuration(resource)
    if resource.is_a? String then
      scrape(resource)
    else
      parse_page(resource)
    end
  end

  def scrape(url)
    @agent ||= Mechanize.new
    page = @agent.get(url)
    parse_page(page)
  end
end