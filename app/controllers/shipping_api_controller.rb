class ShippingApiController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :rates

  def rates
    render json: {}
  end

  private

  def set_origin
  end

  def set_destination
  end

  def set_package
  end

  def set_shipping_rate
    @shipping_rate = ShippingRate.new(@origin, @destination, @package)
  end
end
