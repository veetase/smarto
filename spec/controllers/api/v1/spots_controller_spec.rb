require 'rails_helper'

RSpec.describe Api::V1::SpotsController, :type => :controller do
  describe "GET #show" do
    before(:each) do
      @spot = FactoryGirl.create :spot
      get :show, id: @spot.id
    end

    it "returns the information about a reporter on a hash" do
      spot_response = json_response
      expect(spot_response[:picture]).to eql @spot.picture
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @spot_attributes = FactoryGirl.attributes_for :spot
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, spot: @spot_attributes }
      end

      it "renders the json representation for the spot record just created" do
        spot_response = json_response
        expect(spot_response[:perception]).to eql @spot_attributes[:perception]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_spot_attributes = FactoryGirl.attributes_for(:spot, location: nil)
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, spot: @invalid_spot_attributes }
      end

      it "renders an errors json" do
        spot_response = json_response
        expect(spot_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        spot_response = json_response
        expect(spot_response[:errors][:location]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
  	before(:each) do
      @user = FactoryGirl.create :user
      @spot = FactoryGirl.create :spot, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, { user_id: @user.id, id: @spot.id }
    end

    it { should respond_with 204 }
  end

  describe "GET #around" do
    before(:each) do
      2.times do
        FactoryGirl.create(:spot, location: {type: "Point", coordinates: [-110, 32]})
      end

      3.times do
        FactoryGirl.create(:spot, location: {type: "Point", coordinates: [-100, 32]})
      end

      get :around, { coordinate: [-111, 30], distance: 245, area_id: "101010100" }
    end

    it "return 5 spots around" do
      spots_response = json_response
      expect(spots_response[:spots].count).to eql 2
    end

    it "should get weather info" do
      spots_response = json_response
      expect(spots_response[:weather_cn]).not_to eql nil
    end

    it { should respond_with 200 }
  end

end
