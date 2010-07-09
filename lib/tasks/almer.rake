require 'xls_parser'

class AlmerXLSParser < XLSParser

  def self.rows_to_skip
    117
  end

  def self.should_parse_row(row)
    row[0].blank?
  end

  def self.indexes
    { :warehouse => 1, :description => 2, :vendor => nil, :price => 4 }
  end

  def self.company_name
    "Almer"
  end

end

namespace :app do

  desc "Parse #{AlmerXLSParser.company_name} price list"
  task :almer => :environment do
    AlmerXLSParser.parse_price '/home/vic/tmp/almer.xls', 'windows-1251'
  end
end

