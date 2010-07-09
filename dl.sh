cd ~/tmp
wget "http://www.fcenter.ru/products/price/price.zip"
wget "http://www.oldi.ru/price/oldiprr.zip"
wget "http://www.citilink.ru/price/"
wget "http://www.almer.ru/files_price/almer.zip"
unzip -o almer
unzip -o oldiprr.zip
unzip -o price
mv index.html index.zip
unzip -o index

