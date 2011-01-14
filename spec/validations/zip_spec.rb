require File.dirname(__FILE__) + "/../../range-value-service.rb"

describe "zip validations" do
  it "should return true if value is 5 digit number" do
    JSON.parse( validate_value("zip", "98746") )["status"].should == "pass"
    JSON.parse( validate_value("zip", "57868") )["status"].should == "pass"
    JSON.parse( validate_value("zip", "00001") )["status"].should == "pass"
  end

  it "should fail if value not 5 characters/digits" do
    return_data = JSON.parse( validate_value("zip", "987463") )
    return_data["status"].should == "fail"
    return_data["message"].should == "the zip code must be 5 digits in length"
  end

  it "should fail if there are any nondigits" do
    return_data = JSON.parse( validate_value("zip", "234k3") )
    return_data["status"].should == "fail"
    return_data["message"].should == "only numbers can be used"
  end

end