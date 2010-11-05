# encoding: UTF-8

require 'xls_parser'

class OldiXLSParser < XLSParser

  COMPANY_NAME = "Oldi"

  def rows_to_skip
    800
  end

  def should_parse_row(row)
    return false unless row[3]
    row[3].starts_with? 'Комплектующие для ПК'
  end

  def indexes
    { :warehouse => 0, :description => 1, :vendor => 15, :price => 5 }
  end

end

namespace :app do

  desc "Parse #{OldiXLSParser::COMPANY_NAME} price list"
  task :oldi => :environment do
    OldiXLSParser.parse_price '/home/vic/tmp/oldiprr.xls'
  end
end

