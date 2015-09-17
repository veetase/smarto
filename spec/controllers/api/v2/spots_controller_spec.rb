require 'rails_helper'

RSpec.describe Api::V2::SpotsController, :type => :controller do
  before(:each) do
    api_header(2)
    api_response_format
  end

  describe "GET #show" do
    context 'spot' do
      before(:each) do
        @spot = FactoryGirl.create :spot
        get :show, id: @spot.id, type: "spot"
      end

      it "returns the information about a reporter on a hash" do
        spot_response = json_response
        expect(spot_response[:image]).to eql @spot.image
      end

      it { should respond_with 200 }
    end
    context 'station_spot' do
      before(:each) do
        @station_spot = FactoryGirl.create :station_spot
        get :show, id: @station_spot.id, type: "station_spot"
      end

      it "returns the information about a reporter on a hash" do
        spot_response = json_response
        expect(spot_response[:city]).to eql @station_spot.city
      end

      it { should respond_with 200 }
    end
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

  # describe "GET #around" do
  #   before(:each) do
  #     FactoryGirl.create(:spot, location: "POINT(-110 30)")
  #     get :around, {area_id: "101010100", lon: -111.44, lat: 30.25, distance: 1060000}
  #   end
  #
  #   it "return the spot around" do
  #     spots_response = json_response
  #     expect(spots_response[:spots].count).to eql 1
  #   end
  #   it { should respond_with 200 }
  # end
  #
  # describe "GET #around when city is shenzhen" do
  #   before(:each) do
  #     FactoryGirl.create(:station_spot, location: "POINT(-110 30)")
  #     get :around, {area_id: "101280601", lon: -111.44, lat: 30.25, distance: 1060000}
  #   end
  #
  #   it "should get station_spot info" do
  #     spots_response = json_response
  #     expect(spots_response[:station_spots]).not_to eql nil
  #   end
  #   it { should respond_with 200 }
  # end

  describe "POST #like" do
    context "spot" do
      before(:each) do
        @spot = FactoryGirl.create(:spot)
        post :like, {id: @spot.id, type: 'spot' }
      end

      it { should respond_with 204 }
    end

    context "station_spot" do
      before(:each) do
        @spot = FactoryGirl.create(:station_spot)
        post :like, {id: @spot.id, type: 'station_spot'}
      end

      it { should respond_with 204 }
    end
  end

  describe "POST #unlike" do
    context "spot" do
      before(:each) do
        @spot = FactoryGirl.create(:spot)
        post :unlike, {id: @spot.id, type: 'spot' }
      end

      it { should respond_with 204 }
    end

    context "station_spot" do
      before(:each) do
        @spot = FactoryGirl.create(:station_spot)
        post :unlike, {id: @spot.id, type: 'station_spot'}
      end

      it { should respond_with 204 }
    end
  end
end
