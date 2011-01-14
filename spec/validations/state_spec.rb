require File.dirname(__FILE__) + "/../../range-value-service.rb"

describe "state validations" do
  it "should return true if value matches one of the USPS state codes" do
    JSON.parse( validate_value("state", "CA") )["status"].should == "pass"
    JSON.parse( validate_value("state", "DE") )["status"].should == "pass"
    JSON.parse( validate_value("state", "GA") )["status"].should == "pass"
  end

  it "should fail and send appropriate message if length is not two" do
    response_data = JSON.parse( validate_value("state", "ATD") )
    response_data["status"].should == "fail"
    response_data["message"].should == "you must enter two characters"
  end

  it "should fail and send appropriate message if uppercase not used" do
    response_data = JSON.parse( validate_value("state", "Ca") )
    response_data["status"].should == "fail"
    response_data["message"].should == "you must enter all uppercase letters"
    response_data = JSON.parse( validate_value("state", "ca") )
    response_data["status"].should == "fail"
    response_data["message"].should == "you must enter all uppercase letters"
  end

  it "should fail and send appropriate message if characters are not used" do
    response_data = JSON.parse( validate_value("state", "13") )
    response_data["status"].should == "fail"
    response_data["message"].should == "only characters (not numbers or symbols) may be used"
  end

  it "should return false if value does not match one of the USPS state codes" do
    response_data = JSON.parse( validate_value("state", "ZZ") )
    response_data["status"].should == "fail"
    response_data["message"].should == "the code you entered was not a valid state code"
  end
end