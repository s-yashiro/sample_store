FactoryBot.define do
  factory :trade_log do
    user { nil }
    log_type { 1 }
    action { 1 }
    order_id { "" }
    quantity { "" }
    total { "" }
  end
end
