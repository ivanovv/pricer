# encoding: UTF-8
require 'xls_parser'

class AlmerXLSParser < XLSParser

  COMPANY_NAME = "Almer"
  DEFAULT_FILE_PATH = '/home/vic/tmp/almer.xls'
  DEFAULT_ENCODING = 'windows-1251'


  def rows_to_skip
    117
  end

  def should_parse_row(row)
    row[0].blank?
  end

  def indexes
    { :warehouse => 1, :description => 2, :vendor => nil, :price => 4, :web_link => 9 }
  end

end

#namespace :app do
#
#  desc "Parse #{AlmerXLSParser::COMPANY_NAME} price list"
#  task :almer => :environment do
#    AlmerXLSParser.parse_price AlmerXLSParser::DEFAULT_FILE_PATH, AlmerXLSParser::DEFAULT_ENCODING
#  end
#end

