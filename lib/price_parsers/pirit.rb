# encoding: UTF-8
require 'xls_parser'

module PriceParsers

  class PiritXLSParser < XLSParser
    
    COMPANY_NAME = "Pirit"
    DEFAULT_FILE_PATH = '~/tmp/pirit_price.xls'

    def rows_to_skip
      5
    end

    def should_skip_row(row)
      !row[1].starts_with?('Комплектующие')
    end

    def should_stop(row)
      row[1].starts_with?("Клавиатуры, 'мыши', планшеты, манипуляторы")
    end

    def should_parse_row(row)
      return false unless row[0]
      row[3].starts_with? 'Комплектующие для ПК'
    end

    def indexes
      {:warehouse => 0, :description => 1, :price => 3, :web_link => 0}
    end

  end
end