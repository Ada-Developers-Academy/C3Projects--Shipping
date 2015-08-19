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
    ups = ActiveShipping::UPS.new(login: 'your ups login', password: 'your ups password', key: 'your ups xml key')
    get_rates_from_shipper(ups)
  end

  def usps_rates
    usps = ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'])
    format_usps_rates(get_rates_from_shipper(usps))
  end

  private

  def get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, package)
    response.rates
  end

  def format_usps_rates(rates)
    rates.sort_by(&:price).map{ |rate|
      { rate.service_name => { price: rate.price } }
    }
  end

  def valid_locations # OPTIMIZE: it might be fun to make these error messages be more descriptive / include location errors
    self.errors.add(:origin, "is not valid.") unless self.origin.is_a?(ShippingLocation) && self.origin.valid?
    self.errors.add(:destination, "is not valid.") unless self.destination.is_a?(ShippingLocation) && self.destination.valid?
  end

  def valid_package
    self.errors.add(:package, "is not valid.") unless self.package.is_a?(ActiveShipping::Package)
  end
end
