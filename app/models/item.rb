class Item < ApplicationRecord
  belongs_to :seller, class_name: 'User', foreign_key: :seller_id
  has_one :order_detail
end