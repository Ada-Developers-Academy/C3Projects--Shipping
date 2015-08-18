require 'rails_helper'
require 'shipping'

RSpec.describe Shipping do
  describe "validations" do
    let(:to_OR) { Shipping.new name: "Joe", city: "Portland", state: "Oregon", zip: 97203, length: 22, width: 15, height: 5, weight: 10}

    it "requires a name" do
      s = Shipping.new
      expect(s).to_not be_valid
      expect(s.errors.keys).to include :name
    end

  end
end
