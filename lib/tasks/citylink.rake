require 'xls_parser'

class CityLinkXLSParser < XLSParser

  def self.rows_to_skip
    299
  end

  def self.should_parse_row(row)
    return false unless row[0]
    row[0].starts_with? 'Компьютеры и комплекту'
  end

  def self.indexes
    { :warehouse => 3, :description => 5, :vendor => 4, :price => 6 }
  end

  def self.company_name
    "CityLink"
  end

end

namespace :app do

  desc "Parse CityLink price list"
  task :citylink => :environment do
    CityLinkXLSParser.parse_price '/home/vic/tmp/CitilinkPrice_1.xls'
  end
end

