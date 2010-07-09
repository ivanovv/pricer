require 'price_parser'

class XLSParser < PriceParser

  def self.parse_price(book_path, encoding=nil)
    book = Spreadsheet.open book_path
    book.encoding = encoding if encoding
    sheet =  book.worksheet 0
    company = find_company
    sheet.each rows_to_skip do |row|
      next if row[ indexes[:description] ].blank?
      desc = normalize_description(row[ indexes[:description] ])
      Price.create(
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

