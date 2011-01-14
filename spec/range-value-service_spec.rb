require File.dirname(__FILE__) + "/../range-value-service.rb"
require 'rspec'
require 'rack/test'
require 'test/unit'
require 'sinatra'
require 'json'
Test::Unit::TestCase.send :include, Rack::Test::Methods

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  Sinatra::Application
end

describe "range-value-service" do
  it "should return pass status if data entered is valid" do
    get "/api/v1/validate?field_type=state;field_value=CA"
    last_response.should be_ok
    attributes = JSON.parse(last_response.body)
    attributes["status"].should == "pass"
  end

  it "should return fail status if data entered is invalid" do
    get "/api/v1/validate?field_type=state;field_value=California"
    last_response.should be_ok
    attributes = JSON.parse(last_response.body)
    attributes["status"].should == "fail"
  end

  it "should return an explanation if data is invalid" do
    get "/api/v1/validate?field_type=state;field_value=California"
    last_response.should be_ok
    attributes = JSON.parse(last_response.body)
    attributes["message"].should == "the state must be entered as a two character code"
  end

end