require 'rails_helper'

RSpec.describe Spot, :type => :model do
  before { @spot = FactoryGirl.build(:spot) }

  subject { @spot }

  it { should respond_to(:location) }
  it { should respond_to(:picture) }
  it { should respond_to(:perception) }
  it { should respond_to(:env_info) }
  it { should respond_to(:user) }

  it { should be_valid }
  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:picture) }
  it { should validate_presence_of(:env_info) }
  it { should validate_presence_of(:user) }
end
