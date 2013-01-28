# encoding: UTF-8
require 'company_info'
require 'config_spider'

module Spiders

  class OldiSpider < ConfigSpider

    include ::CompanyInfo
    belongs_to_company "Oldi"

    set_domain "www.oldi.ru"

    def get_page(page_number)
      @page_number = page_number
      @pages_tried = 1
      while @pages_tried < 7 do
        url = absolute_url("/catalog/configurator/?edit_order=#{@page_number}")
        page = @agent.get(url)
        active_nav_links = page.search(".compid")
        if active_nav_links.respond_to?(:size) && active_nav_links.size > 0
          return page
        else
          @page_number += 1
          @pages_tried += 1
          sleep @sleep_time
        end
      end
      nil
    end

    def parse_page(page_number)
      page = get_page(page_number)
      return @page_number unless page
      url = @agent.page.uri.to_s
      if no_configuration_in_db(url)
        config_page = page
        config_record = ScrapedConfiguration.new(:url => url)
        config = scraper(url).parse(config_page)
        ConfigurationSaver.save(config_record, config)
      end
      @page_number + 1
    end
  end
end