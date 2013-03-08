# encoding: UTF-8
class ConfigurationScraper

  include ::CompanyInfo

  def parse(url_or_page)
    scraped_configuration = get_configuration(url_or_page)
    scraped_configuration[:company_id] = company.id
    scraped_configuration
  end

  def parse_page
    raise "Not implemented"
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

  def import_price_from_config(code, desc, link, price)
    price_saver = PriceSaver.new company
    price, action = price_saver.create_price({
                                                 :warehouse_code => code,
                                                 :price => price,
                                                 :original_description => desc,
                                                 :web_link => link
                                             })
    price
  end
end