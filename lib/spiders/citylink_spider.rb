# encoding: UTF-8
require 'company_info'

module Spiders

  class CitylinkSpider
    include ::CompanyInfo
    belongs_to_company "CityLink"

    attr_accessor :sleep_time

    HTTP_PREFIX = "http://"
    CITILINK_DOMAIN = "www.citilink.ru"

    def initialize
      @agent = Mechanize.new
      @agent.user_agent = "Mozilla/5.0 (Ubuntu; X11; Linux x86_64; rv:8.0) Gecko/20100101 Firefox/8.0"
      @agent.cookie_jar << Mechanize::Cookie.new("conf_arc", "1", :domain => CITILINK_DOMAIN, :path => "/")
      @sleep_time = 7
    end

    def get_page(page_number)
      url = absolute_url("/configurator/?p=#{page_number}&showOrder=0222&showType=0")
      page = @agent.get(url)
      active_nav_links = page.search(".b .active")
      if active_nav_links.respond_to? :first
        actual = active_nav_links.first.text
        raise "Wrong page number after fetching page. Expected #{page_number}. Got #{actual}" if actual != page_number.to_s
      else
        raise "No nav links found"
      end
      page
    end

    def parse_page(page_number)
      page = get_page(page_number)
      links = page.links_with(:href => /configurator\/q/)
      sleep @sleep_time
      links.each do |link|
        scrap_config(link)
        sleep @sleep_time
      end
    end

    def scrap_config(mechanize_link)
      url = absolute_url(mechanize_link.href)
      if no_configuration_in_db(url)
        config_page = mechanize_link.click
        config_record = ScrapedConfiguration.new(:url => url)
        config = scraper.parse(config_page)
        ConfigurationSaver.save(config_record, config)
      end
    end

    private

    def no_configuration_in_db(url)
      !ScrapedConfiguration.find_by_url(url)
    end

    def scraper
      @scraper ||= ConfigurationScraperFactory.create_scraper(url)
    end

    def absolute_url(relative_link)
      HTTP_PREFIX + CITILINK_DOMAIN + relative_link
    end

    def create_cookie
      cookie = Mechanize::Cookie.new("conf_arc", "1")
      cookie.domain = CITILINK_DOMAIN
      cookie.secure = false
      cookie.path = "/"
      cookie.version = 0
      cookie
    end

  end
end