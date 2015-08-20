class ShippingApiController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :rates

  def rates
    render json: {}
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

  def set_origin
  end

  def set_destination
  end

  def set_package
  end

  def set_shipping_rate
    @shipping_rate = ShippingRate.new(@origin, @destination, @package)
  end

  def log_params
    params.require(:log).permit(:customer, :order_id, :service, :cost, :origin, :destination)
  end
end
