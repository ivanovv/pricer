module Scrapers
  class OldiScraper < ConfigurationScraper

    COMPANY_NAME = "Oldi"

    def parse_page(page)
      prices = []
      assembly_price = page.search("#total_price_services").text.gsub(/\D/, '').to_i
      total_price = page.search("#total_price").text.gsub(/\D/, '').to_i
      page.search('.componentstype').each do |comp|
        if comp.search('.compid')
          warehouse_code = comp.search('.compid').text
          if !warehouse_code.empty?
            price = company.prices.find_by_warehouse_code(warehouse_code)
            price_val = comp.search('.pricecom').text.gsub(/\D/, '').to_i
            prices << {:price => price, :value => price_val} if price #todo - way to handle wh code not found in our base
          end
        end
      end
      {:title => "", :prices => prices, :assembly_price => assembly_price, :total_price => total_price}
    end
  end
end