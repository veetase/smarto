require 'rails_helper'

RSpec.describe Api::V1::UsersController, :type => :controller do
  before(:each) do
    @user = FactoryGirl.create :user
  end

  describe "GET #show" do
    before(:each) do
      get :show, id: @user.id
    end

    it "returns the information about a reporter on a hash" do
      expect(json_response[:nick_name]).to eql @user.nick_name
    end

    it { should respond_with 200 }
  end

  # describe "POST #create" do
  #   context "when is successfully created" do
  #     before(:each) do
  #       @user_attributes = FactoryGirl.attributes_for :user
  #       post :create, { user: @user_attributes }
  #     end

  #     it "renders the json representation for the user record just created" do
  #       expect(json_response[:email]).to eql @user_attributes[:email]
  #     end

  #     it { should respond_with 201 }
  #   end

  #   context "when is not created" do
  #     before(:each) do
  #       #notice I'm not including the email
  #       @invalid_user_attributes = { password: "12345678",
  #                                    password_confirmation: "12345678" }
  #       post :create, { user: @invalid_user_attributes }
  #     end

  #     it "renders an errors json" do
  #       expect(json_response).to have_key(:errors)
  #     end

  #     it "renders the json errors on whye the user could not be created" do
  #       expect(json_response[:errors][:email]).to include "can't be blank"
  #     end

  #     it { should respond_with 422 }
  #   end
  # end

  describe "PUT/PATCH #update" do
    before(:each) do
      api_authorization_header @user.auth_token
      patch :update, { id: @user.id,
                         user: { nick_name: "new_name" } }
    end

    describe "when is successfully updated" do
      it "renders the json representation for the updated user" do
        expect(json_response[:nick_name]).to eql "new_name"
      end

      it { should respond_with 200 }
    end
  end

  describe "when is not created" do
    before(:each) do
      api_authorization_header @user.auth_token
      patch :update, { id: @user.id,
                         user: { nick_name: "new_namenew_namenew_namenew_namenew_name" } }
    end

    it "renders an errors json" do
      expect(json_response).to have_key(:errors)
    end

    it { should respond_with 422 }
  end

  describe "GET #change_phone" do
    before(:each) do
      api_authorization_header @user.auth_token
      allow_any_instance_of(User).to receive(:random_code).and_return("1234")
      get :change_phone
    end

    it "should set the user confirmation_token" do
      expect(assigns[:user].confirmation_token).to eql "1234"
    end

    it { should respond_with 200 }
  end

  describe "PUT/PATCH #reset_phone" do
    before(:each) do
      @user = FactoryGirl.create :user, phone: "15966946698", confirmation_token: "1234", confirmation_expire_at: Time.now.since(600)
      api_authorization_header @user.auth_token
    end

    describe "when is successfully updated" do
      before(:each) do
        patch :reset_phone, {user: { confirm_token: "1234", phone: "13888888888" } }
      end
      it "should change the user's phone number to the new one" do
        expect(assigns[:user].phone).to eql "13888888888"
        expect(assigns[:user].confirmation_token).to eql nil
        expect(assigns[:user].confirmation_expire_at).to eql nil
      end

      it { should respond_with 204 }
    end

    describe "when is not created" do
      before(:each) do
        patch :reset_phone, {user: { confirm_token: "4321", phone: "18789898989" } }
      end

      it "renders an errors json" do
        expect(json_response).to have_key(:errors)
      end

      it { should respond_with 422 }
    end
  end
end
