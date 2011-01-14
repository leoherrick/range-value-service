require File.dirname(__FILE__) + "/../../range-value-service.rb"

describe "date (six digit) validation" do

  it "should fail if the date is not nn/nn/nn" do
    attributes = JSON.parse(
      validate_value("date_six_digit", "12/12/aa")
    )
    attributes["status"].should == "fail"
  end
    
  it "should fail if the month is over 12" do
    attributes = JSON.parse(
      validate_value("date_six_digit", "13/12/12")
    )
    attributes["status"].should == "fail"
    attributes["message"].should == "the month cannot be greater than 12" 
  end  
  
  it "should fail if the date is > 29 in february" do
    attributes = JSON.parse(
      validate_value("date_six_digit", "02/30/12")
    )
    attributes["status"].should == "fail"
    attributes["message"].should == "the date cannot be greater than 29 for this month" 
  end

  it "should fail if the date is > 30 in a 30 day month" do
    attributes = JSON.parse(
      validate_value("date_six_digit", "11/31/12")
    )
    attributes["status"].should == "fail"
    attributes["message"].should == "the date cannot be greater than 30 for this month" 
  end

  it "should fail if the day is over 31" do
    attributes = JSON.parse(
      validate_value("date_six_digit", "12/32/12")
    )
    attributes["status"].should == "fail"
    attributes["message"].should == "the date cannot be greater than 31"
  end
  
  it "should pass if the date is of valid nn/nn/nn format" do
    attributes = JSON.parse(
      validate_value("date_six_digit", "12/12/12")
    )
    attributes["status"].should == "pass"
  end

end