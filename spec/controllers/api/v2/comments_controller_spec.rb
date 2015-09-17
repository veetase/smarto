require 'rails_helper'

RSpec.describe Api::V2::CommentsController, :type => :controller do
  let (:spot) { FactoryGirl.create :spot }
  let (:station_spot) { FactoryGirl.create :station_spot }
  describe "GET index" do
    context 'spot' do
      before(:each) do
        @spot_comment = FactoryGirl.create :comment, commentable: spot
        get :index, {spot_id: spot.id, type: 'spot'}
      end
      it { should respond_with 200 }
    end

    context 'station spot' do
      before(:each) do
        @spot_comment = FactoryGirl.create :comment, commentable: station_spot
        get :index, {spot_id: station_spot.id, type: 'station_spot'}
      end
      it { should respond_with 200 }
    end
  end

  describe "POST #create" do
    context 'spot' do
      before(:each) do
        user = FactoryGirl.create :user
        api_authorization_header user.auth_token
        comment = FactoryGirl.attributes_for :comment
        post :create, { spot_id: spot.id, type: 'spot', comment: comment }
      end

      it { should respond_with 204 }
    end

    context 'station spot' do
      before(:each) do
        user = FactoryGirl.create :user
        api_authorization_header user.auth_token
        comment = FactoryGirl.attributes_for :comment
        post :create, { spot_id: station_spot.id, type: 'station_spot', comment: comment }
      end

      it { should respond_with 204 }
    end
  end
end
