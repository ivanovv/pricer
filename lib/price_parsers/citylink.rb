# encoding: UTF-8

require 'xls_parser'

module PriceParsers

  class CityLinkXLSParser < XLSParser

    belongs_to_company "CityLink"
    DEFAULT_FILE_PATH = '~/tmp/CitilinkPrice_1.xls'

    def rows_to_skip
      6
    end

    def should_parse_row
      return false unless @row[0]
      @row[0].starts_with?('Компьютеры и комплекту') && !@row[1].starts_with?("Компьютеры")
    end

    def initial_row?
      @row[1] && @row[1].starts_with?('Процессоры')
    end

    def should_stop?
      @row[0].starts_with?('Монитор')
    end

    def indexes
      {:warehouse => 3, :description => 5, :vendor => 4, :price => 6}
    end

  end
end