class Log < ActiveRecord::Base
  validates :customer, :order_id, :service, :cost, :origin, :destination, presence: true
end
