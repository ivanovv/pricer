class ConfigurationScraper

  include ::CompanyInfo

  def parse(url, page = nil)
    scraped_configuration = get_config(url, page)
    scraped_configuration[:company_id] = company.id
    scraped_configuration
  end

  def get_config(url, page)
    page == nil ? scrape(url) : parse_page(page)
  end

  def scrape(url)
    @agent ||= Mechanize.new
    page = @agent.get(url)
    parse_page(page)
  end
end