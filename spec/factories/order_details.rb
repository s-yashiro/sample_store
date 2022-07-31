FactoryBot.define do
  factory :order_detail do
    order_id { nil }
    item_id { nil }
    buyer_id { nil }
    seller_id { nil }
  end
end
