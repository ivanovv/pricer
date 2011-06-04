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

  def initial_row?(row)
    false
  end

  def preprocess_price_attributes(price_attributes)
    
  end

  def parse_price(book_path, encoding = nil)
    book = Spreadsheet.open book_path
    book.encoding = encoding if encoding
    sheet = book.worksheet 0
    @total_rows = sheet.row_count
    sheet.each rows_to_skip do |row|

      next if !initial_row_found?(row)
      break if should_stop?(row)
      next if row[indexes[:description]].blank?

      desc = PriceDescriptionNormalizer.normalize_description(row[indexes[:description]].to_s)
      if should_parse_row(row)
        @parsed_rows += 1
        price_attributes = { :company_id => company.id,
            :warehouse_code => row[indexes[:warehouse]],
            :description => desc,
            :price => row[indexes[:price]],
            :original_description => row[indexes[:description]],
            :vendor_code => indexes[:vendor] ? row[indexes[:vendor]] : nil,
            :web_link => indexes[:web_link] ? row[indexes[:web_link]] : nil
        }
        preprocess_price_attributes(price_attributes)
        create_price(price_attributes)
      end
    end
    puts stats
  end

  def initial_row_found?(row)
    if !@initial_row_found
      @initial_row_found = initial_row?(row)      
    end
    @initial_row_found
  end

  def stats
    "#{company_name}: Total rows in price-list: #{@total_rows} Parsed_rows: #{@parsed_rows} Created prices: #{@created_prices} Updated_prices: #{@updated_prices}"
  end

  def description_index
    indexes[:description]
  end

  def warehouse_code_index
    indexes[:warehouse]
  end
end

