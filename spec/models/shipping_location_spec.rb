require 'rails_helper'
require 'shipping_location'

RSpec.describe ShippingLocation do
  let(:valid_loc) { ShippingLocation.new(city: "Beaverton", state: "OR", zip: 97005, country: "USA")}
  let(:invalid_loc) { ShippingLocation.new }
  describe "validations" do
    context "invalid" do
      it "requires a city" do
        expect(invalid_loc).to_not be_valid
        expect(invalid_loc.errors.keys).to include :city
      end

      it "requires a state/province" do
        expect(invalid_loc).to_not be_valid
        expect(invalid_loc.errors.keys).to include :province
      end

      it "requires a zip/postal code" do
        expect(invalid_loc).to_not be_valid
        expect(invalid_loc.errors.keys).to include :postal_code
      end

      it "requires a country" do
        expect(invalid_loc).to_not be_valid
        expect(invalid_loc.errors.keys).to include :country
      end
    end

    context "valid" do
      it "should be a valid instance" do
        expect(valid_loc).to be_valid
        expect(valid_loc).to be_an_instance_of ShippingLocation
      end
    end

    context "inheritance" do
      it "should be a child of ActiveShipping::Location" do
        expect(ShippingLocation.ancestors).to include ActiveShipping::Location
      end
    end
  end
end






