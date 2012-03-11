# encoding: UTF-8
require 'price_parser'

class XLSParser < PriceParser

  def initialize
    super
    @parsed_rows = 0
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
    true
  end

  def preprocess_price_attributes(price_attributes)
    
  end

  def parse_price(book_path, encoding = nil)
    @started_at = Time.now
    book = Spreadsheet.open book_path
    @file_size = File.size(book_path)
    book.encoding = encoding if encoding
    sheet = book.worksheet 0
    @total_rows = sheet.row_count
    sheet.each rows_to_skip do |row|
      @row = row

      next if !initial_row_found?
      break if should_stop?
      next if description.blank?

      desc = PriceDescriptionNormalizer.normalize_description(description.to_s)
      if should_parse_row
        @parsed_rows += 1
        price_attributes = { :company_id => company.id,
            :warehouse_code => warehouse_code,
            :description => desc,
            :price => price,
            :original_description => description,
            :vendor_code => vendor_code,
            :web_link => web_link
        }
        preprocess_price_attributes(price_attributes)
        create_price(price_attributes)
      end
    end
    puts stats
  end

  def description
    @row[indexes[:description]]
  end

  def web_link
    indexes[:web_link] ? @row[indexes[:web_link]] : nil
  end

  def vendor_code
    indexes[:vendor] ? @row[indexes[:vendor]] : nil
  end

  def price
    @row[indexes[:price]]
  end

  def warehouse_code
    @row[indexes[:warehouse]]
  end

  def initial_row_found?
    if !@initial_row_found
      @initial_row_found = initial_row?
    end
    @initial_row_found
  end

  def stats
    ParsingResult.create_from_parser(self, @started_at, @file_size)
    "#{company_name}: Total rows in price-list: #{@total_rows} Parsed_rows: #{@parsed_rows} Created prices: #{@created_prices} Updated_prices: #{@updated_prices}"
  end

  def description_index
    indexes[:description]
  end

  def warehouse_code_index
    indexes[:warehouse]
  end
end

