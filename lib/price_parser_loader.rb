class PriceParserLoader
  extend Rake::DSL

  def self.load_parser(*files)

    #require_relative "../lib/#{file}.rb"
    files.each do |file|
      require File.join(File.dirname(__FILE__), "../lib/price_parsers/#{file}.rb")
    end

    #TODO rewrite with just compiling class name instead of searching for class name
    ObjectSpace.each_object(Class) do |excel_parser|
      next unless [PriceParser, XLSParser].include?(excel_parser.superclass)
      next if excel_parser == XLSParser
      next if self.check_parser_filename(excel_parser.name, files)
      next if !defined?(excel_parser::COMPANY_NAME)

      string_to_cut_out = excel_parser.superclass == XLSParser ? XLSParser.name : "Parser"
      name = excel_parser.name.sub(/.*::/, '')
      name = name.sub(string_to_cut_out, '').downcase.to_sym

      desc "Parse #{excel_parser::COMPANY_NAME} price list"
      task name => :environment do
         ActionController::Base.expire_page "/"
        file_name = File.expand_path(excel_parser::DEFAULT_FILE_PATH)
        if defined?(excel_parser::DEFAULT_ENCODING)
          excel_parser.parse_price(file_name, excel_parser::DEFAULT_ENCODING)
        else
          excel_parser.parse_price(file_name)
        end
      end
    end
  end

  def self.check_parser_filename(class_name, files)
    files.none? do |file|
      class_name.downcase.include?(file.downcase)
    end
  end
end

