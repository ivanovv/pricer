module Scrapers
  class MeijinScraper < ConfigurationScraper

    belongs_to_company "Meijin"

    def parse_page(page)
      prices = []
      config_info = get_configuration_info(page)

      links = page.links_with :href => /portal\/pls\/portal\/pcconfiginit/
      link = links.first if links && links.count > 0
      price_page = link.click

      each_component_row(price_page) do |component|
        prices.concat(get_configuration_row(component))
      end

      #calculated_total = prices.sum { |p| p[:value] }
      #raise 'Meijin: Calculated total is not equal to page total!' if calculated_total != config_info[:total_price]

      config_info.merge :prices => prices
    end

    def each_component_row(page, &block)
      page.search('table.cmptab tr').each do |component|
        prop_name_is_empty = component.search('.tdinfo .divnote .propname').empty?
        unless prop_name_is_empty
          link = component.at_css('.tdinfo .divnote .goodsname a')
          #http://www.meijin.ru/shopanlgdflt?goodsid=82747
          warehouse_code = link ? (link[:href].to_s.match /\?goodsid\=(\d+)/)[1] : nil
          block.call(component) if warehouse_code && !warehouse_code.empty?
        end
      end
    end

    def get_configuration_row(comp)
      result = []
      link = comp.at_css('.tdinfo .divnote .goodsname a')
      category = comp.at_css('.tdinfo .divnote .propname').text
      warehouse_code = (link[:href].to_s.match /\?goodsid\=(\d+)/)[1]

      price_value = comp.search('.cmpprc .price2').text.gsub(/\D/, '').to_i
      description = "#{category} #{link.text}"
      web_link = warehouse_code

      quantity = comp.at_css('.qty').text.gsub(/\D/, '').to_i
      price_value = (price_value / quantity).to_i if quantity > 1

      price = company.prices.find_by_warehouse_code(warehouse_code)
      price ||= import_price_from_config(warehouse_code, description, web_link, price_value)

      quantity.times { result << {:price => price, :value => price_value} }
      result
    end

    def get_configuration_info(page)
      upper_block = page.search('.frst')
      auth_block = upper_block.at_css('.auth')
      date_span = auth_block.at_css('span')
      {
          :title => upper_block.at_css('.subj').text.strip,
          :total_price => page.search('.glrlft .tvprcno').xpath('p/child::text()').to_s.gsub(/\D/, '').to_i,
          :assembly_price => 0,
          :author => auth_block.at_css('b').text,
          :comment => upper_block.css('.txtd').text.strip,
          :created_at => DateTime.strptime(date_span.text, '%d.%m.%Y %H:%M:%S').change(:offset => '+0400')
      }
    end

  end
end
