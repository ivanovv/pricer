module Scrapers

  class CitylinkScraper < ConfigurationScraper

    belongs_to_company "CityLink"

    HTTP_PREFIX = "http://"
    CITILINK_DOMAIN = "www.citilink.ru"

    def absolute_url(relative_link)
      HTTP_PREFIX + CITILINK_DOMAIN + relative_link
    end

    def parse_page(page)
      prices = []
      title = page.search("div.txt-block h1").text
      total_price = page.search(".price nobr").text.gsub(/\D/, '').to_i
      author = page.search(".conf-link-center a").text
      assembly_price = 0

      part_links = page.search('td.l h2')
      part_links.each do |part_link|
        if part_link.text =~ /(\d+)\s(.+)/
          warehouse_code = $1
          description = $2.strip
          web_link = absolute_url(part_link.search("a").first['href'])
          price = company.prices.find_by_warehouse_code(warehouse_code)
          price ||= company.prices.find_by_warehouse_code(warehouse_code + ".0")

          price_value = part_link.parent.parent.search(".price").text.gsub(/\D/, '')

          price ||= import_price_from_config(warehouse_code, description, web_link, price_value)

          prices << {:price => price, :value => price_value.to_i} if price
        end
      end

      {
          :title => title,
          :author => author,
          :prices => prices,
          :assembly_price => assembly_price,
          :total_price => total_price
      }
    end

    def import_price_from_config(code, desc, link, price)
      price_saver = PriceSaver.new company
      price, action = price_saver.create_price( {
        :warehouse_code => code,
        :price => price,
        :original_description => desc,
        :web_link => link
      })
      price
    end
  end

end