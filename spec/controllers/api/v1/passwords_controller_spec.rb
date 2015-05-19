require 'rails_helper'
RSpec.describe Api::V1::PasswordsController, :type => :controller do
  describe "POST #create, Signin" do
      post :create, { user: {phone: "18665351182"} }
      it { should respond_with 201 }
  end
end
