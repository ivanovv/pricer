
class PriceParserLoader
  def self.load_parser(file)
    
    require_relative "../lib/#{file}.rb"

    ObjectSpace.each_object(Class) do |excel_parser|
      next unless [PriceParser, XLSParser].include?(excel_parser.superclass)
      next if excel_parser == XLSParser
      next if !excel_parser.name.downcase.include?(file.downcase)
      next if !defined?(excel_parser::COMPANY_NAME)
    
      string_to_cut_out = excel_parser.superclass == XLSParser ? XLSParser.name : "Parser"
      name = excel_parser.name.sub(string_to_cut_out, '').downcase.to_sym

      desc "Parse #{excel_parser::COMPANY_NAME} price list"      
      task name => :environment do
        if defined?(excel_parser::DEFAULT_ENCODING)
          excel_parser.parse_price(excel_parser::DEFAULT_FILE_PATH, excel_parser::DEFAULT_ENCODING)
        else
          excel_parser.parse_price(excel_parser::DEFAULT_FILE_PATH)
        end
      end
    end    
  end
end