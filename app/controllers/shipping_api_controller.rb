class ShippingApiController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :rates

  def rates
    render json: {}
  end
end
