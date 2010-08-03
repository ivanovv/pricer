require 'price_parser'
require 'nokogiri'

COMPANY_NAME = "F-Center"

class FCenterParser < PriceParser

  class FCenterPriceDocument < Nokogiri::XML::SAX::Document

    attr_accessor :price_parser

    CATEGORIES = [
      'Процессоры', 'Охлаждающие устройства',
      'Материнские платы', 'Модули памяти',
      'Модули памяти для ноутбуков', 'Накопители на жестких дисках',
      'Контейнеры для жестких дисков, CD-ROM', 'Дисководы',
      'Видеокарты', 'Приводы CD, DVD, BD',
      'Аудиокарты', 'Контроллеры',
      'ТВ-тюнеры, устройства видеозахвата', 'Устройства для ноутбуков и КПК',
      'Корпуса', 'Блоки питания'
    ]
    def start_document
      @in_good_category = true
    end

    def start_element(element, attributes)
      case element
      when 'tr' then
        @is_category_row = attributes[0] == 'class' && attributes[1] == 'e'
        @td_index = 0
        @row_data = {}
      when 'td'
        @in_td = true
        @td_index += 1
      end
    end

    def characters(data)
      unless @in_good_category
        return unless @is_category_row
      end
      if @in_td
        case @td_index
        when 1..2
          @row_data[@td_index] = data
        when 6
          if data =~ /[\d\.]+/
            if @row_data[@td_index]
              @row_data[@td_index] += data
            else
              @row_data[@td_index] = data
            end
          end
        end
      end
    end

    def end_element(element)
      case element
      when 'td' then @in_td = false
      when 'tr'
        case @td_index
        when 2 then @in_good_category = CATEGORIES.include? @row_data[2]
        when 13 then  make_price_record(@row_data) if @in_good_category
        end
      end
    end

    def make_price_record(row)
      original_desc = row[2]
      desc = @price_parser.normalize_description(original_desc)
      warehouse_code = row[1]
      price = row[6]
       @price_parser.create_price(
        :company_id => @price_parser.company.id,
        :warehouse_code => warehouse_code,
        :description => desc,
        :original_description => original_desc,
        :price => price
      )
    end
  end

  def company_name
    COMPANY_NAME
  end

  def self.parse_price(path)
    document = FCenterPriceDocument.new
    document.price_parser = new
    parser = Nokogiri::HTML::SAX::Parser.new(document, 'windows-1251')
    parser.parse_file(path, 'windows-1251')
  end

end

namespace :app do

  desc "Parse #{COMPANY_NAME} price list"
  task :fcenter => :environment do
    FCenterParser.parse_price '/home/vic/tmp/price.html'
  end
end

