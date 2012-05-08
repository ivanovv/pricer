module Scrapers
  class OldiScraper < ConfigurationScraper

    belongs_to_company "Oldi"

    def parse_page(page)
      prices = []
      assembly_price = page.search("#total_price_services").text.gsub(/\s/, '').to_i
      total_price = page.search("#total_price").text.gsub(/\s/, '').to_i
      title = (page.uri.to_s.match /\/\?edit_order\=(\d+)/)[1]
      page.search('.componentstype').each do |comp|
        if comp.search('.compid')
          warehouse_code = comp.search('.compid').text
          if !warehouse_code.empty?
            price = company.prices.find_by_warehouse_code(warehouse_code)
            price_value = comp.search('.pricecom').text.gsub(/\s/, '').to_i
            description = comp.search('.local:not(.hide)').text
            web_link = warehouse_code
            price ||= import_price_from_config(warehouse_code, description, web_link, price_value)
            prices << {:price => price, :value => price_value} if price #todo - way to handle wh code not found in our base
          end
        end
      end
      {:title => title, :prices => prices, :assembly_price => assembly_price, :total_price => total_price}
    end
  end
end
