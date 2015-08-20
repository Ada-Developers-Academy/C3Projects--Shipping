class ShippingApiController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :rates
  before_action :set_shipping_rate, only: :rates

  def rates
    if @shipping_rate.valid?
      estimates = @shipping_rate.ups_rates + @shipping_rate.usps_rates
      render json: estimates
    else
      render json: @shipping_rate.errors
    end
  end

  private

  def origin
    ShippingLocation.new(origin_params)
  end

  def origin_params
    params.require(:origin).permit(:city, :state, :zip, :country)
  end

  def destination
    ShippingLocation.new(destination_params)
  end

  def destination_params
    params.require(:destination).permit(:city, :state, :zip, :country)
  end

  def package
    weight = package_params[:weight].to_i
    dimensions = package_params[:dimensions].map{|d| d.to_i}
    options = { units: package_params[:units]}
    ActiveShipping::Package.new(weight, dimensions, options)
  end

  def package_params
    params.require(:package).permit(:weight, :units, :dimensions => [])
  end

  def set_shipping_rate
    @shipping_rate = ShippingRate.new(attributes = { origin: origin, destination: destination, package: package } )
  end

end
