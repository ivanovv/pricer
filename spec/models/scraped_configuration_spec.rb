require File.dirname(__FILE__) + '/../spec_helper'

describe ScrapedConfiguration do
  it "should be valid" do
    ScrapedConfiguration.new.should be_valid
  end
end
