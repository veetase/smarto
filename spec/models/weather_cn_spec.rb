require 'rails_helper'
require 'grab/weather_cn'
RSpec.describe WeatherCn, :type => :model do
  before { @weather = WeatherCn.new("101010100") }

  subject { @weather }

  it { should respond_to(:index_f) }
  it { should respond_to(:forecast_f) }
  it { should respond_to(:index_v) }
  it { should respond_to(:forecast_v) }

  describe "grab weather info" do
    it "should return correct data" do
      ["index_v", "forecast_v"].each do |t|
        ret = @weather.send(t.to_sym)
        expect(ret.code).to eql 200
        expect(ret.parsed_response).not_to eql "data error" 
      end
    end
  end  
end