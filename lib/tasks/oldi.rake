require 'xls_parser'

class OldiXLSParser < XLSParser

  def self.rows_to_skip
    1032
  end

  def self.should_parse_row(row)
    return false unless row[3]
    row[3].starts_with? 'Комплектующие для ПК'
  end

  def self.indexes
    { :warehouse => 0, :description => 1, :vendor => 15, :price => 5 }
  end

  def self.company_name
    "Oldi"
  end

end

namespace :app do

  desc "Parse #{OldiXLSParser.company_name} price list"
  task :oldi => :environment do
    OldiXLSParser.parse_price '/home/vic/tmp/oldiprr.xls'
  end
end

