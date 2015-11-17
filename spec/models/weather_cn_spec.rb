require 'rails_helper'
require 'grab/weather'
RSpec.describe Weather, :type => :model do
  before { @weather = WeatherCn.new("101010100") }

  subject { @weather }

  it { should respond_to(:index_v) }
  it { should respond_to(:forecast_v) }

  describe "grab weather info" do
    it "should return correct data" do
      ["index_v", "forecast_v"].each do |t|
        ret = @weather.send(t.to_sym)
        expect(ret).not_to eql nil
      end
    end
  end
end
