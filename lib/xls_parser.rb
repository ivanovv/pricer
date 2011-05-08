# encoding: UTF-8
require 'price_parser'

class XLSParser < PriceParser

  def initialize
    super
    @parsed_rows = 0
    @total_rows = 0
    @initial_row_found = false
  end

  def self.parse_price(book_path, encoding = nil)
    parser = new
    parser.parse_price(book_path, encoding)
  end

  def should_stop?(row)
    false
  end

  def should_skip_row?(row)
    false
  end

  def parse_price(book_path, encoding = nil)
    book = Spreadsheet.open book_path
    book.encoding = encoding if encoding
    sheet = book.worksheet 0
    @total_rows = sheet.row_count
    sheet.each rows_to_skip do |row|

      next if row[ indexes[:description] ].blank?
      if !@initial_row_found
        next if !initial_row?(row)
      end
      break if should_stop?(row)

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

  def initial_row?(row)
    if !should_skip_row?(row)
      @initial_row_found = true
    end
    @initial_row_found
  end
  
  def stats
    "#{company_name}: Total rows in price-list: #{@total_rows} Parsed_rows: #{@parsed_rows} Created prices: #{@created_prices} Updated_prices: #{@updated_prices}"
  end
end

