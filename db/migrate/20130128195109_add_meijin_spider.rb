class AddMeijinSpider < ActiveRecord::Migration
  def up
    Company.create(
      :name => "Meijin",
      :base_product_link => "http://www.meijin.ru/shopanlgdflt?goodsid=",
      :home_link => "http://www.meijin.ru/",
      :search_url => "http://www.meijin.ru/pcsearch?fkey="
    )
    Spider.create(:company_id => Company.find_by_name("Meijin").id,
                  :last_page => 687446)

  end

  def down
  end
end
