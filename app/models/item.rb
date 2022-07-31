class Item < ApplicationRecord
  include Discard::Model

  belongs_to :seller, class_name: 'User', foreign_key: :seller_id
  has_one :order_detail

  enum status: [:selling, :sold]

  validates :name, :price, presence: true
end