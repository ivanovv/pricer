# encoding: UTF-8
require 'company_info'
require 'config_spider'

module Spiders

  class MeijinSpider < ConfigSpider
    include ::CompanyInfo

    belongs_to_company "Meijin"
    set_domain "www.meijin.ru"


    def get_page(page_number)
      @page_number = page_number
      @next_page_number = 0

      url = absolute_url("/pcconfig?baseid=#{page_number}&tab=cfg")
      page = @agent.get(url)

      @next_page_number = get_next_page_number(page)

      active_nav_links = page.search(".frst .auth span")
      active_nav_links.empty? ? nil : page
    end


    def get_next_page_number(page)
      nav_arrows = page.search("#ptlmsgp.smsg .msgnvg table tr a img")
      return 0 if nav_arrows.empty?

      nav_arrows.each do |arrow|
        if arrow["src"].include?("arrow-left")
          link = arrow.parent
          return link["href"][/\d+/].to_i
        end
      end

    end

    def parse_page(page_number)
      page = get_page(page_number)
      return page_number unless page

      url = @agent.page.uri.to_s
      if no_configuration_in_db(url)
        config_page = page
        config_record = ScrapedConfiguration.new(:url => url)
        config = scraper(url).parse(config_page)
        ConfigurationSaver.save(config_record, config)
      end
      @next_page_number > 0 ? @next_page_number : page_number
    end

  end
end
