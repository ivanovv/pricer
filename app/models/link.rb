class Link < ActiveRecord::Base
  attr_accessible :item_id, :price_id, :item, :price, :human, :score

  after_save :update_other_parties


  belongs_to :price
  belongs_to :item



  def update_other_parties
    self.price.many_items_found=false
    self.price.save
  end
  
end
