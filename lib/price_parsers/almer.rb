# encoding: UTF-8
require 'xls_parser'

module PriceParsers

  class AlmerXLSParser < XLSParser

    belongs_to_company "Almer"

    DEFAULT_FILE_PATH = '~/tmp/almer.xls'
    DEFAULT_ENCODING = 'windows-1251'

    def rows_to_skip
      100
    end

    def initial_row?
      description.starts_with?('Материнские платы')
    end

    def should_stop?
      description.starts_with?('Источники бесперебойн')
    end

    def should_parse_row
      @row[0].blank?
    end

    def indexes
      {:warehouse => 1, :description => 2, :vendor => nil, :price => 4, :web_link => 9}
    end

  end
end