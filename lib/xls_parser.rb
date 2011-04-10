# encoding: UTF-8
require 'price_parser'

class XLSParser < PriceParser



  def initialize
    super
    @parsed_rows = 0
    @total_rows = 0
  end

  def self.parse_price(book_path, encoding = nil)
    parser = new
    parser.parse_price(book_path, encoding)
  end

  def parse_price(book_path, encoding = nil)
    book = Spreadsheet.open book_path
    book.encoding = encoding if encoding
    sheet = book.worksheet 0
    sheet.each rows_to_skip do |row|
      @total_rows += 1
      next if row[ indexes[:description] ].blank?
      desc = PriceDescriptionNormalizer.normalize_description(row[ indexes[:description] ])
      if should_parse_row(row)
        @parsed_rows += 1
        create_price(
          :company_id => company.id,
          :warehouse_code => row[ indexes[:warehouse] ],
          :description => desc,
          :price => row[ indexes[:price] ],
          :original_description => row[ indexes[:description] ],
          :vendor_code => indexes[:vendor] ? row[ indexes[:vendor] ] : nil,
          :web_link => indexes[:web_link] ? row[ indexes[:web_link] ] : nil
          )
      end
    end
    puts stats
  end
  
  def stats
    "Total rows in price-list: #{@total_rows} Parsed_rows: #{@parsed_rows} Created prices: #{@created_prices} Updated_prices: #{@updated_prices}"
  end
end

