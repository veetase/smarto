require 'rails_helper'

RSpec.describe Address, type: :model do
  it { should respond_to(:name) }
  it { should respond_to(:country) }
  it { should respond_to(:province) }
  it { should respond_to(:city) }
  it { should respond_to(:district) }
  it { should respond_to(:detail) }
  it { should respond_to(:zip_code) }
  it { should respond_to(:tel) }

  it { should validate_presence_of :user_id}
  it { should validate_presence_of :name }
  it { should validate_presence_of :city}
  it { should validate_presence_of :district }
  it { should validate_presence_of :detail }

  it { should belong_to :user }

end
