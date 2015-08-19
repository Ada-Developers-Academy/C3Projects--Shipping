require 'active_shipping'

class ShippingLocation < ActiveShipping::Location
  include ActiveModel::Validations

  validates :country, :city, :province, :postal_code, presence: true

end
