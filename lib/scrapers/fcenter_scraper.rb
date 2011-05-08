module Scrapers

  class FcenterScraper < ConfigurationScraper

    COMPANY_NAME = "F-Center"

    def scrape(url)
      prices = []
      a = url.split "|"

      a.each do |item|
        if item =~ /\d+\:\d+/
          matches = item.match(/(\d+)\:(\d+)/)
          price = company.prices.find_by_warehouse_code(matches[1])
          if price
            puts "item :: #{price.original_description} quantity :: #{matches[2]} price :: #{price.price}"
            prices << price
          end
        end
      end
      prices
    end
  end
end