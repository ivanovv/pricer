# encoding: UTF-8

require 'price_parser'
require 'nokogiri'

module PriceParsers

  class FCenterParser < PriceParser

    belongs_to_company "F-Center"

    DEFAULT_FILE_PATH = '~/tmp/price.html'

    class FCenterPriceDocument < Nokogiri::XML::SAX::Document

      attr_accessor :price_parser

      CATEGORIES = [
          'Процессоры', 'Охлаждающие устройства',
          'Материнские платы', 'Модули памяти',
          'Модули памяти для ноутбуков', 'Накопители на жестких дисках',
          'Накопители SSD',
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
            attributes = attributes[0] if (attributes && attributes.count > 0)
            @is_category_row = attributes[0] == 'class' && attributes[1] == 'e'
            @td_index = 0
            @row_data = {}
            price_parser.total_rows += 1
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
            when 1..3
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
          when 'td' then
            @in_td = false
          when 'tr'
            case @td_index
              when 2 then
                @in_good_category = CATEGORIES.include? @row_data[2]
              when 13 then
                make_price_record(@row_data) if @in_good_category
            end
        end
      end

      def make_price_record(row)
        original_desc = row[2] + " " + row[3]
        desc = PriceDescriptionNormalizer.normalize_description(original_desc)
        warehouse_code = row[1]
        price = row[6]
        @price_parser.create_price(
            :company_id => @price_parser.company.id,
            :warehouse_code => warehouse_code,
            :description => desc,
            :original_description => original_desc,
            :price => price,
            :web_link => warehouse_code
        )
      end
    end

    def self.parse_price(path, encoding = 'windows-1251')
      paring_started_at = DateTime.now
      document = FCenterPriceDocument.new
      document.price_parser = new
      parser = Nokogiri::HTML::SAX::Parser.new(document)
      parser.parse_file(path, encoding)
      ParsingResult.create_from_parser(document.price_parser, paring_started_at, File.size(path))
    end
  end
end