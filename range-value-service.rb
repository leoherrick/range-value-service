require 'rubygems'
require 'sinatra'
require 'sinatra/jsonp'

get '/api/v1/validate' do
  @type = params[:field_type]
  @value = params[:field_value]
  validate_value(@type, @value)
end

get '/test' do
  @name = params[:name]
  @name
end  

def validate_value(type, value)
  response = {:status => "pass", :message => ""}
  case type
    when "state"
      state_codes = %w(AL AK AS AZ AR CA CO CT DE DC FM FL GA GU HI ID IL IN IA KS KY LA ME MH MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND MP OH OK OR PW PA PR RI SC SD TN TX UT VT VI VA WA WV WI WY)
      if state_codes.include?(value)
        ## pass!!
      elsif value.length != 2
        response[:status] = "fail"
        response[:message] = "you must enter two characters"
      elsif value =~ /[a-z]/
        response[:status] = "fail"
        response[:message] = "you must enter all uppercase letters"
      elsif value =~ /[^A-Za-z]/
        response[:status] = "fail"
        response[:message] = "only characters (not numbers or symbols) may be used"
      else
        response[:status] = "fail"
        response[:message] = "the code you entered was not a valid state code"
      end
    when "date_six_digit"
      months_with_29_days = [2]
      months_with_30_days = [1, 4, 6, 9, 11]
      months_with_31_days = [3, 5, 7, 8, 10, 12]
      if value =~ /\d{2}\/\d{2}\/\d{2}/
        string = $&.split("/")
        month = string[0].to_i
        day = string[1].to_i
        year = string[2].to_i
        if month > 12
          response[:status] = "fail"
          response[:message] = "the month cannot be greater than 12"
        elsif months_with_29_days.include?(month) && day > 29
          response[:status] = "fail"
          response[:message] = "the date cannot be greater than 29 for this month"
        elsif months_with_30_days.include?(month) && day > 30
          response[:status] = "fail"
          response[:message] = "the date cannot be greater than 30 for this month"
        elsif months_with_31_days.include?(month) && day > 31
          response[:status] = "fail"
          response[:message] = "the date cannot be greater than 31"
        else
          ## pass!
        end
      else
        response[:status] = "fail"
        response[:message] = "the date must be in nn/nn/nn format"
      end
    when "zip"
      if value.length != 5
        response[:status] = "fail"
        response[:message] = "the zip code must be 5 digits in length"
      elsif value =~ /[^0-9]/
        response[:status] = "fail"
        response[:message] = "only numbers can be used"
      end
  end
  response.to_json
end