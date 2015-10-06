class ShippingApiController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:rates, :create_log]
  before_action :set_shipping_rate, only: :rates

  def rates
    if @shipping_rate.valid?
      estimates = @shipping_rate.ups_rates + @shipping_rate.usps_rates
      render json: estimates, status: :ok # TODO: add status code tests
    else
      render json: @shipping_rate.errors, status: :bad_request # TODO: add status code tests

    end
  end

  def create_log
    log = Log.new(log_params)

    if log.save
      render json: log, status: :ok # 200
    else
      render json: log.errors, status: :bad_request # 400
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
    unless package_params[:weight].nil? || package_params[:dimensions].nil? || package_params[:units].nil?
      weight = package_params[:weight].to_i
      dimensions = package_params[:dimensions].map{|d| d.to_i}
      options = { units: package_params[:units]}
      ActiveShipping::Package.new(weight, dimensions, options)
    end
  end

  def package_params
    params.require(:package).permit(:weight, :units, :dimensions => []).to_hash.symbolize_keys!
  end

  def set_shipping_rate
    @shipping_rate = ShippingRate.new(attributes = { origin: origin, destination: destination, package: package } )
  end

  def log_params
    params.require(:log).permit(:customer, :order_id, :service, :cost, :origin, :destination)
  end

end
