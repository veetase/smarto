require 'rails_helper'

RSpec.describe Api::V1::SpotCommentsController, :type => :controller do
  let (:spot) { FactoryGirl.create :spot }
  describe "GET index" do
    before(:each) do
      @spot_comment = FactoryGirl.create :spot_comment, spot: spot
      get :index, {spot_id: spot.id}
    end
    it { should respond_with 200 }
  end

  describe "POST #create" do
    before(:each) do
      user = FactoryGirl.create :user
      api_authorization_header user.auth_token
      comment = FactoryGirl.attributes_for :spot_comment
      post :create, { spot_id: spot.id, spot_comment: comment }
    end

    it { should respond_with 204 }
  end
end
