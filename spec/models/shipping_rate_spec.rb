require 'rails_helper'
require 'shipping_rate'

RSpec.describe ShippingRate do
  describe 'validations' do
    let(:location1) { ShippingLocation.new(country: 'US', state: 'CA', city: 'Beverly Hills', zip: '90210') }
    let(:location2) { ShippingLocation.new(country: 'US', state: 'WA', city: 'Seattle', zip: '98101') }
    let(:package) { ActiveShipping::Package.new(12, [15, 10, 4.5], :units => :imperial) }

    it 'is valid' do
      r = ShippingRate.new(origin: location1, destination: location2, package: package)

      expect(r).to be_valid
    end

    it 'requires an origin' do
      r = ShippingRate.new(destination: location2, package: package)

      expect(r).to be_invalid
      expect(r.errors).to include :origin
    end

    it 'requires a destination' do
      r = ShippingRate.new(origin: location1, package: package)

      expect(r).to be_invalid
      expect(r.errors).to include :destination
    end

    it 'requires a package' do
      r = ShippingRate.new(origin: location1, destination: location2)

      expect(r).to be_invalid
      expect(r.errors).to include :package
    end

    describe "location validations" do
      let(:location_string) { "location" }
      let(:invalid_location) { ShippingLocation.new(country: 'US', state: 'WA', city: 'Seattle') }

      describe "origin" do
        it "does not accept a string" do
          r = ShippingRate.new(origin: location_string, destination: location2, package: package)

          expect(r).to be_invalid
          expect(r.errors).to include :origin
        end

        it "does not accept an invalid location object" do
          r = ShippingRate.new(origin: invalid_location, destination: location2, package: package)

          expect(r).to be_invalid
          expect(r.errors).to include :origin
        end
      end

      describe "destination" do
        it "does not accept a string" do
          r = ShippingRate.new(origin: location1, destination: location_string, package: package)

          expect(r).to be_invalid
          expect(r.errors).to include :destination
        end

        it "does not accept an invalid location object" do
          r = ShippingRate.new(origin: location1, destination: invalid_location, package: package)

          expect(r).to be_invalid
          expect(r.errors).to include :destination
        end
      end
    end

    describe "package validations" do
      let(:package_string) { "package" }

      it "does not accept a string" do
        r = ShippingRate.new(origin: location1, destination: location2, package: package_string)

        expect(r).to be_invalid
        expect(r.errors).to include :package
      end
    end
  end

  describe "UPS" do
    let(:location1) { ShippingLocation.new(country: 'US', state: 'CA', city: 'Beverly Hills', zip: '90210') }
    let(:location2) { ShippingLocation.new(country: 'US', state: 'WA', city: 'Seattle', zip: '98101') }
    let(:package) { ActiveShipping::Package.new(12, [15, 10, 4.5], :units => :imperial) }
    let(:ups) {ShippingRate.new(origin: location1, destination: location2, package: package)}
    let(:response) {VCR.use_cassette("/ups_rates", record: :new_episodes) {ups.ups_rates}}

    it "returns shipping info" do
      expect(response).to be_an_instance_of Hash
    end

    it "should sort by price" do
      expect(response["UPS Ground"]["price"]).to be < response["UPS Three-Day Select"]["price"]
    end
  end
end








