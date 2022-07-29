FactoryBot.define do
  factory :item do
    name      { "Good Item" }
    price     { 500 }
    status    { 0 }
    seller_id { nil }
  end
end