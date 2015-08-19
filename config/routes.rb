Rails.application.routes.draw do

  post '/rates', to: 'shipping_api#rates'

end
