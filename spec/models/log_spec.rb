require 'rails_helper'

RSpec.describe Log, type: :model do
  describe "validations" do
    it "is valid" do
      expect(build(:log)).to be_valid
    end

    it "requires customer" do
      log = build(:log, customer: nil)

      expect(log).to be_invalid
      expect(log.errors).to include(:customer)
    end

    it "requires order_id" do
      log = build(:log, order_id: nil)

      expect(log).to be_invalid
      expect(log.errors).to include(:order_id)
    end

    it "requires service" do
      log = build(:log, service: nil)

      expect(log).to be_invalid
      expect(log.errors).to include(:service)
    end

    it "requires cost" do
      log = build(:log, cost: nil)

      expect(log).to be_invalid
      expect(log.errors).to include(:cost)
    end

    it "requires origin" do
      log = build(:log, origin: nil)

      expect(log).to be_invalid
      expect(log.errors).to include(:origin)
    end

    it "requires destination" do
      log = build(:log, destination: nil)

      expect(log).to be_invalid
      expect(log.errors).to include(:destination)
    end
  end
end
