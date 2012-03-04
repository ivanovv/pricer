# encoding: UTF-8

require 'xls_parser'

module PriceParsers

  class OldiXLSParser < XLSParser

    belongs_to_company "Oldi"

    DEFAULT_FILE_PATH = '~/tmp/oldiprr.xls'

    def rows_to_skip
      800
    end

    def should_parse_row
      return false unless category_name
      category_name.starts_with? 'Комплектующие для ПК'
    end

    def indexes
      {:warehouse => 0, :description => 1, :vendor => 15, :price => 5, :web_link => 0}
    end

    def should_stop?
      category_name.starts_with?('Мониторы')
    end

    def initial_row?
      return false unless category_name
      category_name.starts_with?('Комплектующие для ПК')
    end

    def category_name
      @row[3]
    end
    
  end
end

#namespace :app do
#
#  desc "Parse #{OldiXLSParser::COMPANY_NAME} price list"
#  task :oldi => :environment do
#    OldiXLSParser.parse_price OldiXLSParser::DEFAULT_FILE_PATH
#  end
#end

