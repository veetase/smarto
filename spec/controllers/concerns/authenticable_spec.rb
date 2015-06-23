require 'spec_helper'
describe Authenticable do
  describe "#current_app_user" do
    before do
      @user = FactoryGirl.create :user
      request.headers["Authorization"] = @user.auth_token
    end
    it "returns the user from the authorization header" do
      expect(current_app_user.auth_token).to eql @user.auth_token
    end
  end
end
