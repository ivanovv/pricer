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
      links = get_links(page)
      sleep @sleep_time
      links.each do |link|
        scrap_config(link.link, link.date)
        sleep @sleep_time
      end
      update_created_at(page_number - 4650)
      page_number = page_number - 1 if links.count < 15
      page_number
    end

    def update_created_at(page_number)
      page = get_page(page_number)
      links = get_links(page)
      links.each do |link|
        update_single_created_at(link.link, link.date)
      end
    end

    def update_single_created_at(mechanize_link, config_date)
      url = absolute_url(mechanize_link.href)
      sc = ScrapedConfiguration.find_by_url(url)
      if sc
        sc.created_at = config_date
        sc.save
      end
    end

    def get_links(page)
      configurations = page.search("table.conf")
      link_plus_date = Struct.new(:link, :date)
      configurations.map do |c|
        link = Mechanize::Page::Link.new(c.css("a.trigger").first, @agent, page)
        config_date = c.css("td.r2").first.text
        config_date = Date.strptime(config_date, "%d.%m.%y") + 12.hours
        link_plus_date.new(link, config_date)
      end
    end

    def scrap_config(mechanize_link, config_date)
      url = absolute_url(mechanize_link.href)
      if no_configuration_in_db(url)
        config_page = mechanize_link.click
        config_record = ScrapedConfiguration.new(:url => url, :created_at => config_date)
        config = scraper(url).parse(config_page)
        ConfigurationSaver.save(config_record, config)
      end
    end
  end
end