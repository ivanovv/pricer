# encoding: UTF-8

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
      title = page.search('div.txt-block h1').text
      total_price = page.search('.price nobr').text.gsub(/\D/, '').to_i
      author = page.search('.conf-link-center a').text
      comment = page.search('.column-right div:nth-child(4)').try(:text)
      comment.tr!('Комментарий автора к конфигурации:', '') if comment

      assembly_price = 0

      each_component_row(page) do |part_link|
        matches = part_link.text.match /(\d+)\s(.+)/
        warehouse_code = matches[1]
        description = matches[2]
        web_link = absolute_url(part_link.search('a').first['href'])
        price = company.prices.find_by_warehouse_code(warehouse_code)
        price ||= company.prices.find_by_warehouse_code(warehouse_code + '.0')

        price_value = part_link.parent.parent.search('.price').text.gsub(/\D/, '')

        price ||= import_price_from_config(warehouse_code, description, web_link, price_value)

        prices << {:price => price, :value => price_value.to_i} if price
      end

      {
          :title => title,
          :author => author,
          :comment => comment,
          :prices => prices,
          :assembly_price => assembly_price,
          :total_price => total_price
      }
    end

    def each_component_row(page, &block)
      page.search('.column-center-wide .column-center-wide div td.l h2').each do |component|
        block.call(component) if component.text =~ /(\d+)\s(.+)/
      end
    end

  end
end