require File.dirname(__FILE__) + '/../spec_helper'

describe ConfigurationLine do
  it "should be valid" do
    ConfigurationLine.new.should be_valid
  end
end
