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
  end
end
