Rails.application.routes.draw do

  post '/rates', to: 'shipping_api#rates'
  post '/logs/new', to: 'shipping_api#create_log'

end
