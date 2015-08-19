require 'rails_helper'

RSpec.describe ShippingApiController, type: :controller do

  describe "POST rate_compare" do
    let(:params) {
      { origin: { zip: "98101", city: "Seattle", state: "WA", country: "US"},
        destination: { city: "Beaverton", state: "OR", zip: 97005, country: "USA" },
        package: { weight: 12, dimensions: [15, 10, 4.5], units: :imperial }
      }
    }

    before :each do
      post :rates, params
    end

    context "when params are valid" do
      it "is successful" do
        expect(response.response_code).to eq(200)
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      describe "the returned json object" do
        before :each do
          @object = JSON.parse(response.body)
        end

        it "is an array of hashes"

        it "includes only service, price, and delivery_date"
      end
    end
  end

end
