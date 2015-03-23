require 'rails_helper'

RSpec.describe User, :type => :model do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }
  it { should validate_presence_of(:email) }
  #it is a bug
  #it { should validate_uniqueness_of(:email) } 
  it { should validate_confirmation_of(:password) }
  it { should allow_value('example@domain.com').for(:email) }  
  it { should respond_to(:auth_token) }
  it { should respond_to(:nick_name) }
  it { should respond_to(:gender) }
  it { should respond_to(:body_condition) }


  describe "generate_authentication_token" do
    it "generates a unique token" do
      Devise.stub(:friendly_token).and_return("auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "auniquetoken123"
    end
  end

  describe "fields validation" do
    before(:each) do
      @user = FactoryGirl.build :user
    end

    it "should be invalid when set a invalid height" do
      @user.body_condition = FactoryGirl.attributes_for(:body_condition, height: 1000)
      expect(@user.save).to be false
      expect(@user.errors.count).to be > 0
      expect(@user.body_condition.errors[:height]).to include "must be less than 300"
    end

    it "should be invalid when set a invalid weight" do
      @user.body_condition = FactoryGirl.attributes_for(:body_condition, weight: 1000)
      expect(@user.save).to be false
      expect(@user.errors.count).to be > 0
      expect(@user.body_condition.errors[:weight]).to include "must be less than 500"
    end

    it "should be invalid when set a invalid body_condition" do
      @user.body_condition = FactoryGirl.attributes_for(:body_condition, tags: ["tag1", "tag1", "tag13 and this tag length is greater than 20. la la la "]) 

      expect(@user.save).to be false
      expect(@user.body_condition.errors[:tags].count).to be > 1
      expect(@user.body_condition.errors[:tags]).to include "body condition tags count at most 2"
      expect(@user.body_condition.errors[:tags]).to include "tag is too long, max length is 20"
    end
  end

  
end
