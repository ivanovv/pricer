class ConfigurationLine < ActiveRecord::Base
  attr_accessible :price_id, :quantity, :price_value, :description, :scraped_configuration_id

  belongs_to :price
  belongs_to :scraped_configuration
  
  validates :price_id, :presence => true
  
end
