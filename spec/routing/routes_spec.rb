# require 'spec_helper'
# require 'constraints/api_constraints'
# describe ApiConstraints, type: :routing do
#   describe "spots" do
#     it "requrest with api subdomain should pass in" do
#       expect(:get => "/spots/around/10101010/50.55/50.55/1000", subdomain: 'api', :format => "json").to route_to(
#         :controller => "spots",
#         :area_id => "101010100",
#         :lon => "50.55",
#         :lat => "50.55",
#         :distance => "1000"
#       )
#     end
#   end
# end
