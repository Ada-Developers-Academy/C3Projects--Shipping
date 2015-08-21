require 'rails_helper'

RSpec.describe ShippingApiController, type: :controller do

  describe "POST rates" do
    let(:params) {
      { origin: { zip: "98101", city: "Seattle", state: "WA", country: "US"},
        destination: { city: "Beaverton", state: "OR", zip: 97005, country: "USA" },
        package: { weight: 12, dimensions: [15, 10, 4.5], units: :imperial }
      }
    }


    context "when params are valid" do
      before :each do
        VCR.use_cassette("/rates", record: :new_episodes) do
          post :rates, params
        end
      end

      it "is successful" do
        expect(response.response_code).to eq(200)
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      describe "the returned json object" do
        before :each do
          VCR.use_cassette("/rates", record: :new_episodes) do
            post :rates, params
          end
        end
        let(:object) { JSON.parse(response.body) }

        it "is an array of hashes" do
          expect(object).to be_an_instance_of Array
          expect(object.first).to be_an_instance_of Hash
        end

        it "includes only service, price, and delivery_date" do
          object.each do |instance|
            expect(instance.keys).to eq(["service", "price", "delivery_date"])
          end
        end
      end
    end
    context "invalid" do
      let(:invalid_params) { { origin: { zip: nil, country: "USA", state: nil, city: nil},
                               destination: { zip: nil, country: nil, state: "Seattle", city: nil },
                               package: {weight: nil, units: nil, dimensions: nil} } }
      before :each do
        VCR.use_cassette("/rates", record: :new_episodes) do
          post :rates, invalid_params
        end
      end

      let(:object) { JSON.parse(response.body) }

      it "returns an error message" do
        expect(object.keys).to include "package"
      end
    end
  end

  describe "POST create_log" do
    context "request is valid" do
      before :each do
        @params = attributes_for(:log)
        post :create_log, { log: @params }
      end

      it "returns a 200 (ok)" do
        expect(response.response_code).to eq(200)
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      it "persists a log in the db" do
        expect(Log.count).to eq(1)
      end

      describe "returned json object" do
        let(:object) { JSON.parse(response.body) }

        it "includes the log" do
          log = Log.find_by(@params)
          (@params.keys).each do |key|
            expect(object[key.to_s]).to eq log[key]
          end
        end
      end
    end

    context "request is invalid" do
      before :each do
        post :create_log, { log: attributes_for(:log, customer: nil) }
      end

      it "returns a 400 (bad request)" do
        expect(response.response_code).to eq(400)
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      describe "returned json object" do
        let(:object) { JSON.parse(response.body) }

        it "includes the error messages" do
          expect(object).to eq({"customer"=>["can't be blank"]})
        end
      end
    end
  end
end

