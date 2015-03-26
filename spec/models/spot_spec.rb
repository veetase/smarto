require 'rails_helper'

RSpec.describe Spot, :type => :model do
  before { @spot = FactoryGirl.build(:spot) }

  subject { @spot }
  it { should respond_to(:location) }
  it { should respond_to(:image) }
  it { should respond_to(:image_shaped) }
  it { should respond_to(:perception_value) }
  it { should respond_to(:perception_tags) }
  it { should respond_to(:avg_temperature) }
  it { should respond_to(:mid_temperature) }
  it { should respond_to(:max_temperature) }
  it { should respond_to(:min_temperature) }
  it { should respond_to(:user) }
  it { should respond_to(:is_public) }
  it { should respond_to(:comment) }
  it { should respond_to(:start_measure_time) }
  it { should respond_to(:measure_duration) }

  it { should be_valid }
end
