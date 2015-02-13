require 'spec_helper'
require 'constraints/api_constraints'
describe ApiConstraints do
  let(:url)     { "http://api.domain.com"     }
  let(:bad_url) { "http://bad_url.domain.com" }

  describe "subdomain" do
    it "requrest with api subdomain should pass in" do
      request = double(host: 'api.localhost:3000',
                       headers: {"Accept" => "application/smarto.v1"})
      expect(api_constraints_v1.matches?(request)).to be true
      expect({:get => "#{url}/"})
    end

  end
end
