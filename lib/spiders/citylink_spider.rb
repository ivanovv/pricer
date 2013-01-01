# encoding: UTF-8
require 'company_info'
require 'config_spider'

module Spiders

  class CitylinkSpider < ConfigSpider
    include ::CompanyInfo

    belongs_to_company "CityLink"
    set_domain "www.citilink.ru"

    def initialize
      super
      @agent.cookie_jar << Mechanize::Cookie.new("conf_arc", "1", :domain => self.class.domain, :path => "/")
    end

    def get_page(page_number)
      url = absolute_url("/configurator/?p=#{page_number}&showOrder=0222&showType=0")
      page = @agent.get(url)
      active_nav_links = page.search(".b .active")
      if active_nav_links.respond_to? :first
        raise "First element in navigation links is empty" unless active_nav_links.first
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
      page_number
    end

    def scrap_config(mechanize_link)
      url = absolute_url(mechanize_link.href)
      if no_configuration_in_db(url)
        config_page = mechanize_link.click
        config_record = ScrapedConfiguration.new(:url => url)
        config = scraper(url).parse(config_page)
        ConfigurationSaver.save(config_record, config)
      end
    end
  end
end