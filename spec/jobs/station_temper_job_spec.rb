require 'rails_helper'
RSpec.describe StationTemperJob, :type => :job do
  describe 'grab station temper info' do

    it "works" do
      work = StationTemperJob.new
      expect{work.perform}.to change{StationSpot.count}
    end
  end
end
