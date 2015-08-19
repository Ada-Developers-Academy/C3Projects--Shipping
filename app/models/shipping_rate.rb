require 'active_shipping'

class ShippingRate
  include ActiveModel::Validations

  attr_accessor :origin, :destination, :package

  validates :origin, :destination, :package, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, package)
    response.rates.sort_by(&:price)
  end

  def ups_rates # TODO: put in actual credentials
    ups = ActiveShipping::UPS.new(login: 'your ups login', password: 'your ups password', key: 'your ups xml key')
    get_rates_from_shipper(ups)
  end

  def usps_rates # TODO: put in actual credentials
    usps = ActiveShipping::USPS.new(login: 'your usps account number', password: 'your usps password')
    get_rates_from_shipper(usps)
  end
end
