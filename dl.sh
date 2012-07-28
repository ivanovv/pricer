cd ~/tmp
wget -O price.html -o /dev/null "http://www.fcenter.ru/products/price/price.html"
wget -O - -o /dev/null "http://www.oldi.ru/price/oldiprr.zip" | funzip > oldiprr.xls
wget -O - -o /dev/null "http://www.citilink.ru/price/" | funzip > CitilinkPrice_1.xls
wget -O - -o /dev/null "http://www.almer.ru/price/almer.zip" | funzip > almer.xls
wget -O - -o /dev/null "http://fast.justcom.ru/prices/JUST_All.zip" | funzip > justcom.xls

