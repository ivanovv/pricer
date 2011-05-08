module Scrapers

  class CitylinkScraper < ConfigurationScraper

    COMPANY_NAME = "CityLink"

    def parse_page(page)
      prices = []
      title = page.search("div.txt-block h1").text
      total_price = page.search(".price nobr").text.gsub(/\D/,'').to_i
      assembly_price = 0

      part_links = page.search('td.l h2')
      part_links.each do |part_link|
        if part_link.text =~ /(\d+)\s.+/
          price = company.prices.find_by_warehouse_code($1)
          price ||= company.prices.find_by_warehouse_code($1+".0")
          price_value = part_link.parent.parent.search(".price").text.gsub(/\D/,'')
          prices << {:price => price, :value => price_value.to_i} if price
        end
      end
      
      {:title => title, :prices => prices, :assembly_price => assembly_price, :total_price => total_price}
    end
  end
  
end