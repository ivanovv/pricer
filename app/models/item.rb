class Item < ActiveRecord::Base
    attr_accessible :description, :original_description, :vendor_code
    has_many :prices
end

