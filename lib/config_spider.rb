class ConfigSpider

  HTTP_PREFIX = "http://"

  UBUNTU_USER_AGENT = "Mozilla/5.0 (Ubuntu; X11; Linux x86_64; rv:8.0) Gecko/20100101 Firefox/8.0"
  MAC_USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/534.52.7 (KHTML, like Gecko) Version/5.1.2 Safari/534.52.7"


  class << self; attr_accessor :domain;  end

  def self.set_domain(domain_name)
    @domain = domain_name
  end

  attr_accessor :sleep_time, :agent, :scraper

  def initialize
    @agent = Mechanize.new
    @agent.user_agent = [UBUNTU_USER_AGENT, MAC_USER_AGENT].sample
    @sleep_time = 7
  end

  def scraper(url)
    @scraper ||= ConfigurationScraperFactory.create_scraper(url)
  end

  def no_configuration_in_db(url)
    !ScrapedConfiguration.find_by_url(url)
  end

  def absolute_url(relative_link)
    HTTP_PREFIX + self.class.domain + relative_link
  end

  def parse_page(page_number)
    raise "Implement parse_page(page_number) in your spider!"
  end

end