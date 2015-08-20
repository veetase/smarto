require 'rails_helper'
RSpec.describe TelAttribution, type: :model do
  it { should respond_to(:city) }
  it { should respond_to(:province) }
  it { should respond_to(:isp) }
  it { should respond_to(:user) }
end
