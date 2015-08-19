require 'rails_helper'
require 'shipping_location'

RSpec.describe ShippingLocation do
  describe "validations" do
    it "requires a city" do
      s = ShippingLocation.new
      expect(s).to_not be_valid
      expect(s.errors.keys).to include :city
    end
  end
end
