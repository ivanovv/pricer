require 'xls_parser'

COMPANY_NAME = "Oldi"

class OldiXLSParser < XLSParser

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

  def company_name
    COMPANY_NAME
  end

end

namespace :app do

  desc "Parse #{COMPANY_NAME} price list"
  task :oldi => :environment do
    OldiXLSParser.parse_price '/home/vic/tmp/oldiprr.xls'
  end
end

