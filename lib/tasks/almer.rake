require 'xls_parser'

COMPANY_NAME = "Almer"

class AlmerXLSParser < XLSParser

  def rows_to_skip
    117
  end

  def should_parse_row(row)
    row[0].blank?
  end

  def indexes
    { :warehouse => 1, :description => 2, :vendor => nil, :price => 4 }
  end

  def company_name
    COMPANY_NAME
  end

end

namespace :app do

  desc "Parse #{COMPANY_NAME} price list"
  task :almer => :environment do
    AlmerXLSParser.parse_price '/home/vic/tmp/almer.xls', 'windows-1251'
  end
end

