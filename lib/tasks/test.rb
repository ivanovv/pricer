
kw_index = Hash.new

Price.find_each do |price|

if price.vendor_code
  search_term = price.vendor_code.dup
  keywords = client.keywords search_term, "price_core", true
  keywords = keywords.inject(0) {|i, x| i += x[:docs] }
  doc_count = keywords[:tokenised]
  if kw_index.has_key? search_term
      kw_index[search_term][:count] +=1
  else
      kw_index[search_term] = {:keywords => keywords, :count => 1}
  end
end

end

ap kw_index

