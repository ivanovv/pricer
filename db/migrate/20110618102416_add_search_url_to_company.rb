class AddSearchUrlToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :search_url, :string
    Company.find_by_name("Oldi").update_attribute(:search_url, "http://www.oldi.ru/search/?x=38&y=14&q=")
    Company.find_by_name("F-Center").update_attribute(:search_url, "http://www.fcenter.ru/products.shtml?techpar/act=p:st:0:0:a:a:a:a&oper=::")
    Company.find_by_name("CityLink").update_attribute(:search_url, "http://www.citilink.ru/search/?text=")
    Company.find_by_name("Just-Com").update_attribute(:search_url, "http://www.justcom.ru/search.php?q=")
    Company.find_by_name("Almer").update_attribute(:search_url, "http://almer.ru/catalog/?action=searchprods&all_ptypes=all&product_name=")
  end

  def self.down
    remove_column :companies, :search_url
  end
end
