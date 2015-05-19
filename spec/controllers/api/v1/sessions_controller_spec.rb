require 'rails_helper'

RSpec.describe Api::V1::SessionsController, :type => :controller do
  describe "POST #create, Signin" do
   before(:each) do
      @user = FactoryGirl.create :user
   end

    context "when the credentials are correct" do

      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        credentials = { phone: @user.phone, password: "1234" }
        post :create, { session: credentials }
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end

      it { should respond_with 200 }
    end

    context "when the credentials are incorrect" do

      before(:each) do
        credentials = { email: @user.phone, password: "4321" }
        post :create, { session: credentials }
      end

      it "returns a json with an error" do
        expect(json_response[:errors]).to eql "Invalid email or password"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do

    before(:each) do
      @user = FactoryGirl.create :user
      #sign_in @user, store: false
      @request.env["devise.mapping"] = Devise.mappings[:user]
      delete :logout
    end

    it { should respond_with 204 }

  end
end
