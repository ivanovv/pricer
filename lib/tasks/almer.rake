# encoding: UTF-8
require 'xls_parser'

class AlmerXLSParser < XLSParser

  COMPANY_NAME = "Almer"

  def rows_to_skip
    117
  end

  def should_parse_row(row)
    row[0].blank?
  end

  def indexes
    { :warehouse => 1, :description => 2, :vendor => nil, :price => 4 }
  end

end

namespace :app do

  desc "Parse #{AlmerXLSParser::COMPANY_NAME} price list"
  task :almer => :environment do
    AlmerXLSParser.parse_price '/home/vic/tmp/almer.xls', 'windows-1251'
  end
end

