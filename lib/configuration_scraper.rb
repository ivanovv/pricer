# encoding: UTF-8
class ConfigurationScraper

  include ::CompanyInfo

  def parse(url_or_page)
    scraped_configuration = get_configuration(url_or_page)
    scraped_configuration[:company_id] = company.id
    scraped_configuration
  end

  def parse_page
    raise 'Not implemented'
  end

  def get_configuration(url_or_page)
    if url_or_page.is_a? String then
      scrape(url_or_page)
    else
      parse_page(url_or_page)
    end
  end

  def scrape(url)
    @agent ||= Mechanize.new
    page = @agent.get(url)
    parse_page(page)
  end

  def import_price_from_config(code, desc, link, price)
    raise 'Price should be present!' if price.nil? || price.blank?
    price_saver = PriceSaver.new company
    price_attributes = {
        :warehouse_code => code,
        :price => price,
        :original_description => desc,
        :web_link => link
    }
    price, action = price_saver.create_price(price_attributes)
    price
  end
end