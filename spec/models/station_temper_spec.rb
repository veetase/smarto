require 'rails_helper'
require 'grab/station_temper'
RSpec.describe StationTemper, :type => :model do
  describe 'grab station temper info' do
    let(:including_class) { Class.new { include StationTemper } }

    it "works" do
      locations = JSON.load(File.read(Rails.root.join('lib', 'grab', 'station_locations.json')))

      expect(including_class.new.fetch_station_temper).not_to eql nil
      expect{including_class.new.fetch_station_temper}.to change{StationSpot.count}
    end
  end
end
