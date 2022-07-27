class TradeLog < ApplicationRecord
  belongs_to :user

  enum log_type: [:point]
  enum action: [:pay, :sell, :reward]
end
