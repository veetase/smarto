require 'rails_helper'

RSpec.describe Api::V1::AddressesController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create :user
    api_authorization_header @user.auth_token
  end
  describe "GET #show" do
    before(:each) do
      @address = FactoryGirl.create :address, user: @user
      get :show, id: @address.id, user_id: @user.id
    end

    it "returns the information about a reporter on a hash" do
      address_response = json_response
      expect(address_response[:name]).to eql @address.name
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :address, user: @user }
      get :index, user_id: @user.id
    end

    it "returns 4 records from the database" do
      addresss_response = json_response
      expect(addresss_response.size).to eql 4
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @address_attributes = FactoryGirl.attributes_for :address
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, address: @address_attributes }
      end

      it "renders the json representation for the address record just created" do
        address_response = json_response

        expect(address_response[:name]).to eql @address_attributes[:name]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_address_attributes = FactoryGirl.attributes_for :address, name: nil
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, address: @invalid_address_attributes }
      end

      it "renders an errors json" do
        address_response = json_response
        expect(address_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        address_response = json_response
        expect(address_response[:errors][:name]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @address = FactoryGirl.create :address, user: @user
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @address.id,
              address: { name: "Stephen Wang" } }
      end

      it "renders the json representation for the updated user" do
        address_response = json_response
        expect(address_response[:name]).to eql "Stephen Wang"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @address.id,
              address: { name: nil } }
      end

      it "renders an errors json" do
        address_response = json_response
        expect(address_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        address_response = json_response
        expect(address_response[:errors][:name]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @address = FactoryGirl.create :address, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, { user_id: @user.id, id: @address.id }
    end

    it { should respond_with 204 }
  end
end
