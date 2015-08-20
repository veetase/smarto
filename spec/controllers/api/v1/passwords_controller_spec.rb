require 'rails_helper'
RSpec.describe Api::V1::PasswordsController, :type => :controller do
  describe "POST #create, Signin" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      post :create, { user: {phone: @user.phone} }
    end

    it { should respond_with 201 }
  end
end
