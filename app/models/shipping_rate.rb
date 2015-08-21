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
    format_ups_rates(get_rates_from_shipper(ups))
  end

  def usps_rates
    usps = ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'])
    format_usps_rates(get_rates_from_shipper(usps))
  end

  private

  def format_ups_rates(rates)
    rates.sort_by(&:price).map do |rate|
      { service: rate.service_name, price: rate.total_price, delivery_date: rate.delivery_date }
    end
  end

  def get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, package)
    response.rates
  end

  def format_usps_rates(rates)
    rates.sort_by(&:price).map{ |rate|
      { service: rate.service_name, price: rate.price, delivery_date: rate.delivery_date }
    }
  end

  def valid_locations # OPTIMIZE: it might be fun to make these error messages be more descriptive / include location errors
    unless self.origin.is_a?(ShippingLocation) && self.origin.valid?
      errors = self.origin.is_a?(ShippingLocation) ? self.origin.errors : "It is not an instance of ShippingLocation."
      self.errors.add(:origin, errors)
    end
    unless self.destination.is_a?(ShippingLocation) && self.destination.valid?
      errors = self.destination.is_a?(ShippingLocation) ? self.destination.errors : "It is not an instance of ShippingLocation."
      self.errors.add(:destination, errors)
    end
  end

  def valid_package
    # binding.pry
    self.errors.add(:package, "is not valid.") unless self.package.is_a?(ActiveShipping::Package)
  end
end
