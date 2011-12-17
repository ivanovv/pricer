class CreateSpiders < ActiveRecord::Migration
  def change
    create_table :spiders do |t|
      t.string :url
      t.integer :company_id
      t.integer :last_page

      t.timestamps
    end
    Spider.create(:company_id => Company.find_by_name("CityLink").id, :url => 'http://www.citilink.ru/configurator/?p=#{page_number}&showOrder=0222&showType=0', :last_page => 0)
  end
end
