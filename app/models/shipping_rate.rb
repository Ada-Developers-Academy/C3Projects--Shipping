require 'active_shipping'

class ShippingRate
  include ActiveModel::Validations

  attr_accessor :origin, :destination, :package

  validates :origin, :destination, :package, presence: true
  validate :valid_locations
  validate :valid_package

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def ups_rates # TODO: put in actual credentials
    ups = ActiveShipping::UPS.new(login: ENV["ACTIVESHIPPING_UPS_LOGIN"], password: ENV["ACTIVESHIPPING_UPS_PASSWORD"], key: ENV["ACTIVESHIPPING_UPS_KEY"])
    get_rates_from_shipper(ups)
  end

  def usps_rates # TODO: put in actual credentials
    usps = ActiveShipping::USPS.new(login: 'your usps account number', password: 'your usps password')
    get_rates_from_shipper(usps)
  end

  private

  def get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, package)
    response.rates.sort_by(&:price)
  end

  def valid_locations # OPTIMIZE: it might be fun to make these error messages be more descriptive / include location errors
    self.errors.add(:origin, "is not valid.") unless self.origin.is_a?(ShippingLocation) && self.origin.valid?
    self.errors.add(:destination, "is not valid.") unless self.destination.is_a?(ShippingLocation) && self.destination.valid?
  end

  def valid_package
    self.errors.add(:package, "is not valid.") unless self.package.is_a?(ActiveShipping::Package)
  end
end
