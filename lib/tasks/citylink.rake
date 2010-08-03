require 'xls_parser'

COMPANY_NAME = "CityLink"

class CityLinkXLSParser < XLSParser

  def rows_to_skip
    200
  end

  def should_parse_row(row)
    return false unless row[0]
    row[0].starts_with? 'Компьютеры и комплекту'
  end

  def indexes
    { :warehouse => 3, :description => 5, :vendor => 4, :price => 6 }
  end

  def company_name
    COMPANY_NAME
  end

end

namespace :app do

  desc "Parse #{COMPANY_NAME} price list"
  task :citylink => :environment do
    CityLinkXLSParser.parse_price '/home/vic/tmp/CitilinkPrice_1.xls'
  end
end

