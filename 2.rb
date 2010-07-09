reader = Nokogiri::XML::Reader(File.open('/home/vic/tmp/price.html'), nil, 'windows-1251')
reader.each do |element|
  if element.name == 'td' && element.node_type == 1 # start node for foo
    doc = Nokogiri::XML(element.inner_xml)
    result = doc.at_css('a').text
    puts result
    #doc.css('foo bar baz').last.text
  end
end

