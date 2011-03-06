## encoding: UTF-8
#
#%w[fcenter oldi almer citylink].each do |file|
#  require file
#end
#
#dependencies = []
#
#namespace :app do
#
#  ObjectSpace.each_object(Class) do |excel_parser|
#    next unless [PriceParser, XLSParser].include?(excel_parser.superclass)
#    next if excel_parser == XLSParser
#
#    next if !defined?(excel_parser::COMPANY_NAME)
#    string_to_cut_out = excel_parser.superclass == XLSParser ? XLSParser.name : "Parser"
#    name = excel_parser.name.sub(string_to_cut_out, '').downcase.to_sym
#    desc "Parse #{excel_parser::COMPANY_NAME} price list"
#    task name => :environment do
#      if defined?(excel_parser::DEFAULT_ENCODING)
#        excel_parser.parse_price(excel_parser::DEFAULT_FILE_PATH, excel_parser::DEFAULT_ENCODING)
#      else
#        excel_parser.parse_price(excel_parser::DEFAULT_FILE_PATH)
#      end
#    end
#    dependencies << name
#  end
#
#  dependencies.map! {|dep| "app:#{dep}"}
#
#  desc "Parse all prices"
#  multitask :parse_all_prices => dependencies do
#    puts "All prices parsed!"
#  end
#end
#
#
##  companies = %w[fcenter oldi almer citylink]
##
##  companies.each do |comp|
##    desc "#{comp} launcher task"
##    task "#{comp}_launcher" => :environment do
##      Rake::Task["app:#{comp}"].execute
##    end
##  end
