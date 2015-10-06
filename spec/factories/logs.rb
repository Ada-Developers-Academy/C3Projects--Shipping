FactoryGirl.define do
  factory :log do
    customer "Bitsy"
    order_id "12345"
    service "USPS First Class"
    cost 1234
    origin "98101"
    destination "98102"
  end
end
