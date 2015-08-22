require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!
RSpec.describe User, :type => :model do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }
  it { should respond_to(:phone) }

  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }
  #it is a bug
  #it { should validate_uniqueness_of(:email) }
  it { should allow_value('18867546758').for(:phone) }
  it { should respond_to(:auth_token) }
  it { should respond_to(:nick_name) }
  it { should respond_to(:gender) }
  it { should respond_to(:age) }
  it { should have_many(:products) }
  it { should have_many(:orders) }
  it { should have_many(:addresses) }
  describe "generate_authentication_token" do
    it "generates a unique token" do
      Devise.stub(:friendly_token).and_return("auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "auniquetoken123"
    end
  end

  describe "reset password" do
    it "should change the user reset_password_token" do
      allow_any_instance_of(User).to receive(:random_code).and_return("1234")
      @user.reset_password
      expect(@user.reset_password_token).to eql "1234"
    end

    it "should increment the count" do
      expect{@user.reset_password}.to change{UcSmsJob.jobs.size}.by(1)
    end
  end

  describe "fields validation" do
    before(:each) do
      @user = FactoryGirl.build :user
    end

    it "should be invalid when set a invalid figure" do
      @user.figure = 100
      expect(@user.save).to be false
      expect(@user.errors.count).to be > 0
      expect(@user.errors[:figure]).to include "must be less than 50"
    end

    it "should be invalid when set a invalid age" do
      @user.age = 200
      expect(@user.save).to be false
      expect(@user.errors.count).to be > 0
      expect(@user.errors[:age]).to include "must be less than 130"
    end

    context "tags validation" do
      it "should be invalid when tags is not array" do
        #@user.tags = FactoryGirl.attributes_for(:body_condition, tags: ["tag1", "tag1", "tag13 and this tag length is greater than 20. la la la "])
        @user.tags = 1
        expect(@user.save).to be false
        expect(@user.errors[:tags].count).to be > 0
      end

      it "should be invalid when tag is too long" do
        #@user.tags = FactoryGirl.attributes_for(:body_condition, tags: ["tag1", "tag1", "tag13 and this tag length is greater than 20. la la la "])
        @user.tags = ["one tags is too longggggggggggggggggggggggggggggg"]
        expect(@user.save).to be false
        expect(@user.errors[:tags].count).to be > 0
        expect(@user.errors[:tags]).to include "is invalid"
      end

      it "should be invalid when tags is too many" do
        #@user.tags = FactoryGirl.attributes_for(:body_condition, tags: ["tag1", "tag1", "tag13 and this tag length is greater than 20. la la la "])
        @user.tags = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven"]
        expect(@user.save).to be false
        expect(@user.errors[:tags].count).to be > 0
        expect(@user.errors[:tags]).to include "is invalid"
      end
    end
  end


end
