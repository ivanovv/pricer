# encoding: UTF-8

require 'xls_parser'

class CityLinkXLSParser < XLSParser

  COMPANY_NAME = "CityLink"
  DEFAULT_FILE_PATH = '~/tmp/CitilinkPrice_1.xls'

  def rows_to_skip
    200
  end

  def should_parse_row(row)
    return false unless row[0]
    row[0].starts_with? 'Компьютеры и комплекту' && !row[1].starts_with?("Компьютеры")
  end

  def indexes
    { :warehouse => 3, :description => 5, :vendor => 4, :price => 6 }
  end

end

#namespace :app do
#
#  desc "Parse #{CityLinkXLSParser::COMPANY_NAME} price list"
#  task :citylink => :environment do
#    CityLinkXLSParser.parse_price CityLinkXLSParser::DEFAULT_FILE_PATH
#  end
#end

