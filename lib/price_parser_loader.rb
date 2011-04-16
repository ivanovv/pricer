
class PriceParserLoader
  def self.load_parser(file)
    
    #require_relative "../lib/#{file}.rb"
    require File.join(File.dirname(__FILE__), "../lib/#{file}.rb")


    ObjectSpace.each_object(Class) do |excel_parser|
      next unless [PriceParser, XLSParser].include?(excel_parser.superclass)
      next if excel_parser == XLSParser
      next if !excel_parser.name.downcase.include?(file.downcase)
      next if !defined?(excel_parser::COMPANY_NAME)
    
      string_to_cut_out = excel_parser.superclass == XLSParser ? XLSParser.name : "Parser"
      name = excel_parser.name.sub(string_to_cut_out, '').downcase.to_sym

      desc "Parse #{excel_parser::COMPANY_NAME} price list"      
      task name => :environment do
        file_name = File.expand_path(excel_parser::DEFAULT_FILE_PATH)
        encoding = excel_parser::DEFAULT_ENCODING if defined?(excel_parser::DEFAULT_ENCODING)
        excel_parser.parse_price(file_name, encoding)
      end
    end    
  end
end