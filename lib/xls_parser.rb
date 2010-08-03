require 'price_parser'

class XLSParser < PriceParser

  def self.parse_price(book_path, encoding=nil)
    parser = new
    parser.parse_price(book_path, encoding)
  end

  def parse_price(book_path, encoding=nil)
    book = Spreadsheet.open book_path
    book.encoding = encoding if encoding
    sheet =  book.worksheet 0
    sheet.each rows_to_skip do |row|
      next if row[ indexes[:description] ].blank?
      desc = normalize_description(row[ indexes[:description] ])
      create_price(
        :company_id => company.id,
        :warehouse_code => row[ indexes[:warehouse] ],
        :description => desc,
        :price => row[ indexes[:price] ],
        :original_description => row[ indexes[:description] ],
        :vendor_code => indexes[:vendor] ? row[ indexes[:vendor] ] : nil
        ) if should_parse_row(row)
    end
  end
end

