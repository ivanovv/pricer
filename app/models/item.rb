class Item < ActiveRecord::Base

  attr_accessible :description, :original_description, :vendor_code

  has_many :links
  
  has_many :prices, :through => :links do
    def average_price
      all.average(:price)
    end
  end

  define_index do
    # fields
    indexes description
    indexes original_description
    indexes vendor_code

    #set_property :enable_star => true
    #set_property :min_prefix_len => 3
    #set_property :min_infix_len => 3

    # attributes
    has id
  end


end

